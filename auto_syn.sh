#!/bin/bash

set -e
set -o noclobber

alias cp="cp -i"
unalias cp

# Read optional arguments
technode="${1:-ASAP7}"   # Default: ASAP7
module="${2:-}"          # Default: empty string

# Validate input
if [[ "$technode" != "ASAP7" && "$technode" != "NanGate45" ]]; then
    echo "Error: Invalid technode '$technode'"
    echo "Valid options are: ASAP7, NanGate45"
    exit 1
fi

rename_template_design_in_target_dir() {
    local target_dir="$1"
    local module="$2"

    if [ -z "$target_dir" ] || [ -z "$module" ]; then
        echo "Error: Usage: rename_template_design_in_target_dir <target_dir> <module>" >&2
        return 1
    fi
    if [ ! -d "$target_dir" ]; then
        echo "Error: '$target_dir' is not a directory." >&2
        return 1
    fi

    find "$target_dir" -maxdepth 1 -type f -name '*template_design*' | while IFS= read -r file; do
        filename=$(basename "$file")
        newname="${filename//template_design/$module}"
        mv "$file" "$target_dir/$newname"
        echo "Renamed: $filename → $newname"
    done
}

replace_template_design_and_echo_files() {
    local target_dir="$1"
    local module="$2"

    if [ -z "$target_dir" ] || [ -z "$module" ]; then
        echo "Error: Usage: replace_template_design_and_echo_files <target_dir> <module>" >&2
        return 1
    fi
    if [ ! -d "$target_dir" ]; then
        echo "Error: '$target_dir' is not a directory." >&2
        return 1
    fi

    # Find and replace only in files containing 'template_design'
    grep -rl 'template_design' "$target_dir" | while IFS= read -r file; do
        # Replace in file content
        sed -i "s/template_design/$module/g" "$file"
        # Echo the file name
        echo "Updated: $file"
    done
}

echo "Technode: $technode"
echo ""

mkdir -p ./Flows/$technode

cd ./Flows/$technode


single_run () {
    local technode="$1"
    local module="$2"

    module="${module##*/}"
    echo "Module: $module"
    mkdir -p $module
    cd $module
    echo "Dir: $(pwd)"
    echo ""

    # now in ./Flows/$technode/$module
    echo "Copy template files into ./Flows/$technode/$module"
    cp ../../template_design/* . -r
    echo ""

    echo "Update constraints (.sdc)"
    rename_template_design_in_target_dir constraints $module
    echo ""

    echo "Update definition (.def)"
    rename_template_design_in_target_dir def $module
    echo ""

    echo "Update rtl (.v)"
    rm -rf rtl/*
    cp ../../../src/$module/* rtl
    echo ""

    echo "Update scripts (.tcl)"
    mv ./scripts/setup/$technode/* ./scripts/cadence
    rm -rf ./scripts/setup
    replace_template_design_and_echo_files scripts $module
    echo ""

    echo "Add rtl to rlt_list"
    rtl_dir="./rtl"
    rtl_list_file="./scripts/cadence/rtl_list.tcl"
    rm -rf $rtl_list_file

    # Extract all .v files (relative path)
    verilog_files=()
    while IFS= read -r f; do
        verilog_files+=("../../$f")
    done < <(find "$rtl_dir" -maxdepth 1 -type f -name "*.v" | sort)

    verilog_block=""
    for file in "${verilog_files[@]}"; do
        verilog_block+="  $file"$'\n'
    done

    # Write to file
    echo "set rtl_all {" >> "$rtl_list_file"
    echo -n "$verilog_block" >> "$rtl_list_file"
    echo "}" >> "$rtl_list_file"

    echo "Updated $rtl_list_file with the following Verilog files:"
    printf '  %s\n' "${verilog_files[@]}"
    echo ""
    echo ""

    cd ./scripts/cadence

    # use flow-1
    export PHY_SYNTH=0

    mkdir log -p
    genus -overwrite -log log/genus.log -no_gui -files run_genus_hybrid.tcl
    echo ""
}


if [ -n "$module" ]; then
    single_run $technode $module
else
    echo "No module specified, run all modules"
    echo ""
    for module_inst in $(ls -d ../../src/*)
    do
        single_run $technode $module_inst
    done
fi


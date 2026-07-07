# For more information on defining custom themes, see
# https://www.nushell.sh/book/coloring_and_theming.html
# And here is the theme collection
# https://github.com/nushell/nu_scripts/tree/main/themes
let dark_theme = {
    # color for nushell primitives
    separator: white
    leading_trailing_space_bg: { attr: n } # no fg, no bg, attr none effectively turns this off
    header: green_bold

    # Closures can be used to choose colors for specific values.
    # The value (in this case, a bool) is piped into the closure.
    # eg) {|| if $in { 'light_cyan' } else { 'light_gray' } }
    bool: light_cyan
    int: white
    filesize: cyan
    duration: white
    date: purple
    range: white
    float: white
    string: white
    nothing: white
    binary: white
    cell-path: white
    row_index: green_bold
    record: white
    list: white
    block: white
    hints: dark_gray
    search_result: { bg: red fg: white }
    shape_and: purple_bold
    shape_binary: purple_bold
    shape_block: blue_bold
    shape_bool: light_cyan
    shape_closure: green_bold
    shape_custom: green
    shape_datetime: cyan_bold
    shape_directory: cyan
    shape_external: cyan
    shape_externalarg: green_bold
    shape_external_resolved: light_yellow_bold
    shape_filepath: cyan
    shape_flag: blue_bold
    shape_float: purple_bold
    # shapes are used to change the cli syntax highlighting
    shape_garbage: { fg: white bg: red attr: b }
    shape_glob_interpolation: cyan_bold
    shape_globpattern: cyan_bold
    shape_int: purple_bold
    shape_internalcall: cyan_bold
    shape_keyword: cyan_bold
    shape_list: cyan_bold
    shape_literal: blue
    shape_match_pattern: green
    shape_matching_brackets: { attr: u }
    shape_nothing: light_cyan
    shape_operator: yellow
    shape_or: purple_bold
    shape_pipe: purple_bold
    shape_range: yellow_bold
    shape_record: cyan_bold
    shape_redirection: purple_bold
    shape_signature: green_bold
    shape_string: green
    shape_string_interpolation: cyan_bold
    shape_table: blue_bold
    shape_variable: purple
    shape_vardecl: purple
    shape_raw_string: light_purple
}

let light_theme = {
    # color for nushell primitives
    separator: dark_gray
    leading_trailing_space_bg: { attr: n } # no fg, no bg, attr none effectively turns this off
    header: green_bold
    empty: blue
    # Closures can be used to choose colors for specific values.
    # The value (in this case, a bool) is piped into the closure.
    # eg) {|| if $in { 'dark_cyan' } else { 'dark_gray' } }
    bool: dark_cyan
    int: dark_gray
    filesize: cyan_bold
    duration: dark_gray
    date: purple
    range: dark_gray
    float: dark_gray
    string: dark_gray
    nothing: dark_gray
    binary: dark_gray
    cell-path: dark_gray
    row_index: green_bold
    record: dark_gray
    list: dark_gray
    block: dark_gray
    hints: dark_gray
    search_result: { fg: white bg: red }
    shape_and: purple_bold
    shape_binary: purple_bold
    shape_block: blue_bold
    shape_bool: light_cyan
    shape_closure: green_bold
    shape_custom: green
    shape_datetime: cyan_bold
    shape_directory: cyan
    shape_external: cyan
    shape_externalarg: green_bold
    shape_external_resolved: light_purple_bold
    shape_filepath: cyan
    shape_flag: blue_bold
    shape_float: purple_bold
    # shapes are used to change the cli syntax highlighting
    shape_garbage: { fg: white bg: red attr: b }
    shape_glob_interpolation: cyan_bold
    shape_globpattern: cyan_bold
    shape_int: purple_bold
    shape_internalcall: cyan_bold
    shape_keyword: cyan_bold
    shape_list: cyan_bold
    shape_literal: blue
    shape_match_pattern: green
    shape_matching_brackets: { attr: u }
    shape_nothing: light_cyan
    shape_operator: yellow
    shape_or: purple_bold
    shape_pipe: purple_bold
    shape_range: yellow_bold
    shape_record: cyan_bold
    shape_redirection: purple_bold
    shape_signature: green_bold
    shape_string: green
    shape_string_interpolation: cyan_bold
    shape_table: blue_bold
    shape_variable: purple
    shape_vardecl: purple
    shape_raw_string: light_purple
}

# --- Nushell E-Ink Dark Theme (Elegant Edition) ---
# A minimal, grayscale theme focused on readability and a calm, elegant aesthetic.
# It uses subtle variations in brightness and style to create a clear visual hierarchy.

let e_ink_dark_theme = {
    # The color of the table separator. Kept subtle to not distract from the data.
    separator: '#5E5E5E'

    # The background color for leading/trailing whitespace in tables.
    leading_trailing_space_bg: '#333333'

    # The style for table headers. Brighter and bold to clearly label columns.
    header: [ '#B8B8B8', bold ]

    # --- Data Type Styling ---
    # Primitive values are styled to create a visual rhythm in tables.
    primitive_int: '#A4A4A4'
    primitive_filesize: '#A4A4A4'
    primitive_string: '#C2C2C2'
    primitive_date: '#7C7C7C' # Dates recede slightly as secondary info.
    primitive_boolean: '#B8B8B8'
    primitive_nothing: [ '#686868', dim ] # Null values are dimmed significantly.

    # --- Syntax Highlighting and `ls` Colors ("Shapes") ---
    # This is the core of the theme, defining how different items look.
    shape_directory: [ '#B8B8B8', bold ]  # Directories are bright and bold for easy navigation.
    shape_symlink: [ '#A4A4A4', italic ] # Symlinks are distinct but not overpowering.
    shape_file: '#C2C2C2'              # Regular files are the standard text color.
    shape_executable: [ '#7C7C7C', dim ] # Executables are dimmed to reduce visual noise.
    shape_flag: '#A4A4A4'             # Command flags.
    shape_custom: '#B8B8B8'            # Custom shapes.

    # Shapes for syntax highlighting within the shell.
    shape_keyword: [ '#868686', bold ]
    shape_operator: '#A4A4A4'
    shape_pipe: '#A4A4A4'
    shape_variable: '#CCCCCC' # Variables are the brightest element to stand out in code.
    shape_string: '#C2C2C2'
    shape_string_interpolation: '#A4A4A4'
    shape_matching_paren: [ '#CCCCCC', underline ] # Makes matching parentheses very clear.

    # --- Status and Feedback ---
    # High contrast for errors is crucial for usability.
    shape_error: [ '#CCCCCC', bold, reverse ]
    # Hints for commands are dimmed to be helpful without being intrusive.
    hint: [ '#686868', dim ]
}

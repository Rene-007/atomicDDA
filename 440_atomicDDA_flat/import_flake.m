function flake = import_flake(filename)
%% Import flake data from a flake_growth csv file
%  filename ...PATH + NAME of the csv file
%  flake    ...struct with 
%


    %% MAX values
    opts = delimitedTextImportOptions("NumVariables", 3);

    % Specify range and delimiter
    opts.DataLines = [2, 2];
    opts.Delimiter = " ";

    % Specify column names and types
    opts.VariableNames = ["i_max", "j_max", "k_max"];
    opts.VariableTypes = ["double", "double", "double"];

    % Specify file level properties
    opts.ExtraColumnsRule = "ignore";
    opts.EmptyLineRule = "read";
    opts.ConsecutiveDelimitersRule = "join";
    opts.LeadingDelimitersRule = "ignore";

    % Specify variable properties
    opts = setvaropts(opts, ["i_max", "j_max"], "TrimNonNumeric", true);
    opts = setvaropts(opts, ["i_max", "j_max"], "ThousandsSeparator", ",");

    % Import the data
    flake.space = readtable(filename, opts);
    flake.center = table2array(flake.space)/2;

    %% Extrema
    opts = delimitedTextImportOptions("NumVariables", 1);

    % Specify range and delimiter
    opts.DataLines = [4, 4];
    opts.Delimiter = "";

    % Import the data
    buf = readmatrix(filename, opts);
    names = extract(buf(1,1),regexpPattern('[x-z]_...'));                      % x_min, x_max, y_min, ...
    values = extract(buf(1,1),regexpPattern('.\d*[.]\d*'));                       % "-2.8547401", "2.8547401", "-2.8254597"
    xyz = str2double(values);                                                     

    % flake.extrema = rows2vars(array2table(ijk,'RowNames',names,'VariableNames',{'i','j','k'}));
    flake.extrema = xyz;
    
    %% ExtremaIJK
    opts = delimitedTextImportOptions("NumVariables", 1);

    % Specify range and delimiter
    opts.DataLines = [6, 6];
    opts.Delimiter = "";

    % Import the data
    buf = readmatrix(filename, opts);
    names = extract(buf(1,1),regexpPattern('[x-z]_...'));                      % x_min, x_max, y_min, ...
    values = extract(buf(1,1),regexpPattern('i: \d*\, j: \d*\, k: \d*'));      % ": 2998", ": 3001", "150"
    ijk = extract(values,digitsPattern());                                     % '2998', '3001', '150'
    ijk = str2double(ijk);                                                     % 2998, 3001, 150

    % flake.extrema = rows2vars(array2table(ijk,'RowNames',names,'VariableNames',{'i','j','k'}));
    flake.extremaIJK = ijk - flake.center;

    %% Stacking pos
    opts = delimitedTextImportOptions("NumVariables", flake.space.k_max);

    % Specify range and delimiter
    opts.DataLines = [9, 9];
    opts.Delimiter = ", ";

    % % Specify column names and types
    opts.VariableTypes = repmat("double", 1, flake.space.k_max);

    % Specify file level properties
    opts.ExtraColumnsRule = "ignore";
    opts.EmptyLineRule = "read";
    opts.ConsecutiveDelimitersRule = "join";
    opts.LeadingDelimitersRule = "ignore";

    % % Specify variable properties
    opts = setvaropts(opts, "TrimNonNumeric", true);

    % Import the data
    tbl = readtable(filename, opts);

    % Convert to output type
    flake.stacking.pos = table2array(tbl)';

    %% Stacking shift_j
    opts = delimitedTextImportOptions("NumVariables", flake.space.k_max);

    % Specify range and delimiter
    opts.DataLines = [12, 12];
    opts.Delimiter = ", ";

    % % Specify column names and types
    opts.VariableTypes = repmat("double", 1, flake.space.k_max);

    % Specify file level properties
    opts.ExtraColumnsRule = "ignore";
    opts.EmptyLineRule = "read";
    opts.ConsecutiveDelimitersRule = "join";
    opts.LeadingDelimitersRule = "ignore";

    % % Specify variable properties
    opts = setvaropts(opts, "TrimNonNumeric", true);

    % Import the data
    tbl = readtable(filename, opts);

    % Convert to output type
    flake.stacking.shift_j = table2array(tbl)';


    %% Positions
    opts = delimitedTextImportOptions("NumVariables", 3);

    % Specify range and delimiter
    opts.DataLines = [16, Inf];
    opts.Delimiter = " ";

    % Specify column names and types
    opts.VariableNames = ["a", "b", "c", "d", "surface"];
    opts.VariableTypes = ["double", "double", "double", "double", "double"];

    % Specify file level properties
    opts.ExtraColumnsRule = "ignore";
    opts.EmptyLineRule = "read";
    opts.ConsecutiveDelimitersRule = "join";
    opts.LeadingDelimitersRule = "ignore";

    % Specify variable properties
    opts = setvaropts(opts, ["a", "b", "c", "d", "surface"], "TrimNonNumeric", true);
    opts = setvaropts(opts, ["a", "b", "c", "d", "surface"], "ThousandsSeparator", ",");

    % Import the data
    tbl = readtable(filename, opts);  
    flake.positions = table2array(tbl);

end
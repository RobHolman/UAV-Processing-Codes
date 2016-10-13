function insts = makeDJIInsts201510011529
%   insts = makeDJIInsts
%
% creates pixel instruments for DJI video.  Types can be line or matrix
% this one is empty - just test image products.
cnt = 1;

% vBar instruments
y = [450 700];
x = [125: 25: 225];
z = 0;
for i = 1: length(x)
    insts(cnt).type = 'line';
    insts(cnt).xyz = [x(i) y(1) z; x(i) y(2) z];
    eval(['insts(cnt).name = ''vBar' num2str(x(i)) ''';']);
    eval(['insts(cnt).shortName = ''vBar' num2str(x(i)) ''';']);
    cnt = cnt+1;
end

% some runup lines
x = [70 125];
y = [600:50:650];
z = 0;
for i = 1: length(y)
    insts(cnt).type = 'line';
    insts(cnt).xyz = [x(1) y(i) z; x(2) y(i) z];
    eval(['insts(cnt).name = ''runup' num2str(y(i)) ''';']);
    eval(['insts(cnt).shortName = ''runup' num2str(y(i)) ''';']);
    cnt = cnt+1;
end

% cBathy array
x = [80 5 400];   % determine sample region and spacing
y = [450 5 900];    % format is [min del max]
z = 0;
insts(cnt).type = 'matrix';
insts(cnt).name = 'cBathyArray';
insts(cnt).shortName = 'mBW';
insts(cnt).x = x;
insts(cnt).y = y;
insts(cnt).z = z;
cnt = cnt+1;

% make some slices to check stability
insts(cnt).type = 'line';
insts(cnt).xyz = [300 540 7; 300 500 7];
insts(cnt).name = 'x = 300 pier transect';
insts(cnt).shortName = 'x300Slice';
cnt = cnt+1;

insts(cnt).type = 'line';
insts(cnt).xyz = [100 520 3; 115 520 3];
insts(cnt).name = 'y = 520 Piling x-transect';
insts(cnt).shortName = 'y517Slice';


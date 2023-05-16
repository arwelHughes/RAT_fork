function result = inputTestWrapper(in)

if coder.target('MATLAB')
    result = 2*in;
else
    %out = zeros(4,1);
    out = [0,0];
    N = length(in);
    sourceFile = 'inputTest.c';
    coder.cinclude('inputTest.h');
    coder.updateBuildInfo('addSourceFiles',sourceFile);
    coder.ceval('inputTest',int32(N),coder.ref(in),coder.wref(out));
    result = out(1);
end
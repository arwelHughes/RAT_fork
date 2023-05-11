function out = inputTestWrapper(in)



if coder.target('MATLAB')
    out = 2*in;
else
    out = zeros(4,1);
    N = length(in);
    sourceFile = 'inputTest.c';
    coder.cinclude('inputTest.h');
    coder.updateBuildInfo('addSourceFiles',sourceFile);
    coder.ceval('inputTest',int32(N),coder.ref(in),coder.wref(out));

end
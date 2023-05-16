clear

q = linspace(0.001,0.4,1000);
q = q(:);

sld = [0    complex(0,0)             0
    1.2e3   complex(4.66e-6,1.6e-8) 10
    0       complex(6.3e-6,0)       4];

R = abelesReflectWrapper_mex(q,sld);

% sld2 = [0 2.073e-6  3;
%     200 4e-6 3;
%     100 1e-6 3;
%     0 6.3e-6 4];
% 
% R2 = abelesReflectWrapper_mex(q,sld2);
% 
% % Multilayer....
% sld3 = [200 4e-6 3;
%     100 1e-6 3];
% 
% repeats = 10;
% allSld  = sld3;
% for i = 1:repeats
%     allSld = [allSld ; sld3];
% end
% 
% totSLD3 = [0 2.073e-6 3 ; allSld ; 0 6.3e-6 4];
% R3 = abelesReflectWrapper_mex(q,totSLD3);
% 
% 
% figure(1); clf
% semilogy(q,R);
% hold on
% semilogy(q,R2);
%semilogy(q,R3);


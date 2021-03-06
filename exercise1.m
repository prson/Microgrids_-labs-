clear;
clc;
load('Tram.mat');
pelect=zeros(size(T,2),1);
% Extracting the power demand from the data structure T
for i=1:size(T,2)
    pelect(i,1)=T(1,i).pelec;
end
figure;
plot(1:size(T,2),pelect);
title('Power Supply Profile');
% Calculating the maximum power demand of the time period
pmax=max(pelect);
ptotal=0;
for i=1:size(pelect,1)
    ptotal=ptotal+pelect(i,1);
end
% ptotal=sum(pelect);
% Calculating the average pwower demand over the time period
pavg=ptotal/size(pelect,1);
disp('Average power: ' );
disp(pavg);
% Calculating the PPH
% If both average and maximum are greater than zero, 
% Pavg and Pmax will mostly be greater than zero.
% If it is less than zero, we definitely need storage and hence PPH is set
% to 1.
if(pavg>=0 && pmax>0)
    pph=1-(pavg/pmax);
else
    pph=1;
end
disp('Potential for hybridization in power: ' );
disp(pph)
energyInBatt=zeros(size(pelect,1)-1,1);
% Pavg is assumed to be provided by the external supplier and the peaks
% shall be managed by the storage, so the energy in battery shall be
% calculated on the basis of the difference between the electrical power
% and the average power.
for i=2:size(pelect,1)
    energyInBatt(i,1)=energyInBatt(i-1,1)-(pelect(i-1,1)-pavg);
end
figure;
plot(energyInBatt);
title('Energy in battery (in J)');
% Useful energy of a battery is definaed as the difference between the maximum and
% minimum energy stored in a time cycle
eu=max(energyInBatt)-min(energyInBatt);
disp(strcat('Useful Energy (in Joules): ',num2str(eu)));
if(eu~=0 && pmax>=0)
    phe=pmax/eu;
else
    phe=Inf;
end
disp('Potential for hybridization in energy: ' );
disp(phe)

% So using the PHE and PPH values, we can idetify that either power or
% energy is more influential for the design of the battery system.
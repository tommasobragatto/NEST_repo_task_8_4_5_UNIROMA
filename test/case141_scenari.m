clear all

prova2=loadcase(case141);

% g=graph(prova2.branch(ismember(prova2.branch(:,11),1),1),prova2.branch(ismember(prova2.branch(:,11),1),2));
% G=plot(g,'Layout','force');
CP=prova2.bus(ismember(prova2.bus(:,2),3),1);
% highlight(G,CP,'NodeColor','red');
mpopt=mpoption('verbose',0,'out.all','0');
r=runpf(prova2,mpopt);
OVf= sqrt(r.branch(:,14).^2 + r.branch(:,15).^2);
OVt= sqrt(r.branch(:,16).^2 + r.branch(:,17).^2);
OVm= max(abs(OVf),abs(OVt));

ampacity=5*floor((quantile(OVm,[0.25 0.5 0.75 1])/(sqrt(3)*prova2.bus(1,10)*10^(-3))+5)/5);
% ampacity=sqrt(3)*prova2.bus(1,10)*10^(-3)*ampacity;
for i = 1:length(OVm)
    value = OVm(i)/(sqrt(3)*prova2.bus(1,10)*10^(-3));
    nearestSuperior = ampacity(ampacity > value);
    minSuperior = min(nearestSuperior);
    index = find(ampacity == minSuperior);
    prova2.branch(i,6)=sqrt(3)*prova2.bus(1,10)*10^(-3)*ampacity(index);
end

OVf= sqrt(r.branch(:,14).^2 + r.branch(:,15).^2)  ./ prova2.branch(:,6);
OVt= sqrt(r.branch(:,16).^2 + r.branch(:,17).^2)  ./ prova2.branch(:,6);
OVm= max(abs(OVf),abs(OVt));
length(find(OVm>0.9))

savecase('case141_portate_0',prova2)
prova2.bus(:,3)=prova2.bus(:,3).*(randi(3,[length(prova2.bus(:,1)) 1])+9)/10;
savecase('case141_portate_1',prova2);
prova2=loadcase('case141_portate_0');
prova2.bus(1:round(length(prova2.bus(:,1))/3),3)=prova2.bus(1:round(length(prova2.bus(:,1))/3),3).*(randi(3,[length(prova2.bus(1:round(length(prova2.bus(:,1))/3,1))) 1])+10)/10;
savecase('case141_portate_2',prova2);
prova2=loadcase('case141_portate_0');
prova2.bus(round(length(prova2.bus(:,1))/3):round(length(prova2.bus(:,1))*2/3),3)=prova2.bus(round(length(prova2.bus(:,1))/3):round(length(prova2.bus(:,1))*2/3),3).*(randi(3,[length(prova2.bus(round(length(prova2.bus(:,1))/3):round(length(prova2.bus(:,1))*2/3),3)) 1])+9)/10;
savecase('case141_portate_3',prova2);
prova2=loadcase('case141_portate_0');
prova2.bus(round(length(prova2.bus(:,1))*2/3):end,3)=prova2.bus(round(length(prova2.bus(:,1))*2/3):end,3).*(randi(3,[length(prova2.bus(round(length(prova2.bus(:,1))*2/3):end,1)) 1])+9)/10;
savecase('case141_portate_4',prova2);

% prova2=loadcase(case136ma);
% g=graph(prova2.branch(ismember(prova2.branch(:,11),1),1),prova2.branch(ismember(prova2.branch(:,11),1),2));
% figure(2)
% plot(g,'Layout','force')
% 
% prova2=loadcase(case118zh);
% g=graph(prova2.branch(ismember(prova2.branch(:,11),1),1),prova2.branch(ismember(prova2.branch(:,11),1),2));
% figure(3)
% plot(g,'Layout','force')
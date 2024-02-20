function[G]=group_nodes(mpc)
mpc.branch= mpc.branch(find(mpc.branch(:,11)==1),:); %%% remove branch out of service
BUS_N= length(mpc.bus(:,1)); % non da impostare

for i=1:BUS_N
  G(i).bus=  mpc.bus(i,1);
  G(i).gup=  district_up(mpc,find(mpc.bus(:,2)==3),G(i).bus);
  G(i).down= district_down(mpc,find(mpc.bus(:,2)==3),G(i).bus);
end

end
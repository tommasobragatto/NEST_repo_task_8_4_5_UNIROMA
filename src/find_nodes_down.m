function [NODI_sotto,LEVEL]= find_nodes_down(mpc,MC0,lista,nodo)


% ##mpc.branch= [ 80  85 ;
% ##              73  85 ;
% ##              76  73  ;
% ##              78  73  ;
% ##              91  80  ;
% ##              84  91  ;
% ##              87  84  ];
% ##              
% ##
% ##MC0= [ 0  1  1  0  0  0  0 ;
% ##       -1 0  0  0  1  0  0 ;
% ##       -1 0  0  0  0  0  1 ;
% ##       0  0  0  0  -1 0  0 ;
% ##       0 -1  0  1  0  1  0 ;
% ##       0  0  0  0  -1 0  0 ;
% ##       0  0  -1 0  0  0  0 ];
% ##
% ##lista= [ 80;85;91;76;73;78;84];


  
%nodo= 80;



NODI_sotto= nodo;
pos_nodi2= find( lista==nodo);
vv=0;
LEVEL(1).nodi= nodo;
lv=1;

while 5 > 3
  
  for i=1:length(pos_nodi2)
    
    if length( find( MC0(pos_nodi2(i),:) == 1 ) ) > 0
      
         vv= vv+1;
         l= length( find( MC0(pos_nodi2(i),:) == 1 ) );
         pos_nodi3(vv:vv+l-1,1)= find( MC0(pos_nodi2(i),:) == 1 )';
         %pos_nodi3
         vv= vv+l-1;
         
         
    end
    
  end
  
  
  if vv==0
    break
  end
    
  pos_nodi2= pos_nodi3;
  NODI_sotto2= unique( [ NODI_sotto ; lista(pos_nodi2) ] );
    
  
  if length(NODI_sotto2) == length(NODI_sotto)
        break
  end
  
  NODI_sotto= NODI_sotto2;
  
  vv=0;
  lv=lv+1;
  LEVEL(lv).nodi= lista(pos_nodi2);
  
 
end 
     
              
%NODI_sotto              
% ##for i=1:length(LEVEL)
% ##  LV= LEVEL(i).nodi;
% ##  LV
% ##endfor  
              
              
              
              
              
end
              
              
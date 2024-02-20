function [MC0,lista] = calcolo_MC(mpc,nodo)


NODI_VECCHI= nodo;
lista= unique( [ mpc.branch(:,1) ; mpc.branch(:,2) ] ); %[ 80;85;91;76;73;78;84];


MC0= zeros(length(lista),length(lista));

nodi_n=[];
nodi_n2= nodo;
FINE=[];

while 5>3
  
  
  for j=1:length(nodi_n2)
    
      nodo= nodi_n2(j);
      
   
      nuovi2= mpc.branch( find( mpc.branch(:,1) == nodo ) , 2 );
      nuovi1= mpc.branch( find( mpc.branch(:,2) == nodo ) , 1 );
      nuovi= unique( [nuovi1 ; nuovi2] );
      
      
      for i=1:length(nuovi)
     
        if length( find( NODI_VECCHI == nuovi(i) ) ) > 0
       
          MC0( find(lista==nodo) , find(lista==nuovi(i)) ) = -1;
     
        else
       
          MC0( find(lista==nodo) , find(lista==nuovi(i)) ) = +1;
       
        end
     
      end
     
  
     nodi_n= unique( [ nodi_n ; nuovi ] );
     
  
  FINE= [FINE;nodo]; 
  
     
     
  end

  
  nodi_n3=[];
  
  for vd=1:length(nodi_n)
    
      if length( find( NODI_VECCHI == nodi_n(vd) ) ) == 0
        
        nodi_n3= [ nodi_n3 ; nodi_n(vd) ];
        
      end
          
  end
  
  
  nodi_n= nodi_n3;
  
  
  NODI_VECCHI= unique( [ NODI_VECCHI ; nodi_n ] );
  
  nodi_n2= nodi_n;
  nodi_n=[];
  
  
  
  if length( FINE ) == length(mpc.bus)   %mpc.branch
    break
  end 
   

      end


       
end 
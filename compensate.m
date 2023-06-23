function dataComp = compensate(data, AF, comp_matrix)

     
    dataAF = data'-AF;
    
    dataComp = (comp_matrix \ dataAF)'+AF';
    
end
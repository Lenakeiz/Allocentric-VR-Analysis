function a = extractHeader(x)
    k = strfind(x,'_3.xml');
    a = extractBetween(x,1,k-1);
end

infoldername='C:\Users\¼Ñç÷\Documents\MATLAB\id\target\original RGB pic\';
formatSpec1='%04d.jpg';
formatSpec2='%04d.jpg';
counter=1;
for i=601:759
    imagename=sprintf(formatSpec1,i);
    filepath=[infoldername imagename];
    
    if exist(filepath,'file')==2
        newname=sprintf(formatSpec2,counter);
        new_filepath=[infoldername newname];
        movefile(filepath,new_filepath);
        counter=counter+1;
    end
end



fid=fopen('pos_list.txt','a+');
No_of_positive_samples=600;
No_of_negative_samples=600;

for i=1:No_of_positive_samples
    fprintf(fid,'%04d',i);
    fprintf(fid,'.jpg\r\n');
end
fclose(fid);

fid=fopen('neg_list.txt','a+');
for i=1:No_of_negative_samples
    fprintf(fid,'%04d',i);
    fprintf(fid,'.jpg\r\n');
end
fclose(fid);
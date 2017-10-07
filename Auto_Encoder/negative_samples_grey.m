%%right520-right565   0001-0046
%%right591-right599   0047-0055
%%right642-right707   0056-0121
%%right714-right726   0122-0134
%%right1589-right1602 0135-0148

%%0401-0549           0149-0297
%%0601-0869           0298-0566
%%0870-0903           0567-0600
path='D:\Ñ¸À×ÏÂÔØ\ph\';
formatSpec1='%04d.jpg';
formatSpec2='%04d.jpg';
for i=567:600
    imagename=sprintf(formatSpec1,i+303);
    filepath=[path imagename];
    filename=sprintf(formatSpec2,i);
    find_grey_obj(filepath,filename);
end

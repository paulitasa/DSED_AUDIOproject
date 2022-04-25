[data, fs] = audioread('C:\DSED\DSED_Group16\haha.wav');
file = fopen('sample_in.dat','w');
fprintf(file, '%d\n', round(data.*127));

filter_out = filter([0.039, 0.2422, 0.4453, 0.2422, 0.039],[1, 0, 0, 0, 0], data); %pb
% filter_out = filter([-0.0078, -0.2031, 0.6015, -0.2031, -0.0078],[1, 0, 0, 0, 0], data);%pa
sound(filter_out);


% file3 = load('sample_out.dat');


waitforbuttonpress;

 vhdlout=load('sample_out.dat')/127;
 sound(vhdlout);

 error= [];
 
 for i = 1.0:1.0:11515
     error(i)= abs(filter_out(i)-vhdlout(i));
 end
 
%  bar (error, 'k');
%  title ("Error filtro paso bajo");
 bar(filter_out , 'b');
 title ("Filtros paso bajo");
  hold on

 bar(vhdlout, 'r');
  legend('Filtro ideal calculado con Matlab', 'Filtro generado con el código VHDL');

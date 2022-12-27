function test_text_reader_writer

x = rand(10,3);

headLines=cell(2,1);
headLines{1} = 'abc';
headLines{2} = 'x  y  z';
my_text_writer(x, headLines, 'tmp1.txt');


[y, headLines] = my_text_reader('tmp1.txt', 2)
[z] = my_text_reader('tmp1.txt', 2)

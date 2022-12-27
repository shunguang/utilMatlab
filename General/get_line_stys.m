function [solidLines, dashedLines, dotLines]  = get_line_stys

solidLines  = cell(6,1);
dashedLines = cell(6,1);
dotLines    = cell(6,1);

solidLines{1} = 'b-';
solidLines{2} = 'g-';
solidLines{3} = 'r-';
solidLines{4} = 'c-';
solidLines{5} = 'k-';
solidLines{6} = 'm-';

dashedLines{1} = 'b--';
dashedLines{2} = 'g--';
dashedLines{3} = 'r--';
dashedLines{4} = 'c--';
dashedLines{5} = 'k--';
dashedLines{6} = 'm--';


dotLines{1} = 'b:';
dotLines{2} = 'g:';
dotLines{3} = 'r:';
dotLines{4} = 'c:';
dotLines{5} = 'k:';
dotLines{6} = 'm:';
%eof
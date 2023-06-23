function morpho_gate = createMorphoGate(fileName)
% CREATEMORPHOGATE(fileName)    has the user draw a morphological gate if 
% one doesn't exist based on the fcs file in fileName. Saves the gating polygons 
% and the morphological gating plots in the experiment's metadata folder.
% If a different fileName is given, a new morpho_gate will be created an
% saved.  To redo analysis, delete the current MorphoGate folder.
% 
% Returns a gate [1x3] struct array where each gate contains the fields
% 'chs' and 'pos'
%
%       Morpholigical gating channels are defined below.  If you want to
%       change this, you'll have to change this function.
%       gate1: SSC-A vs. FSC-A
%       gate2: FSC-H vs. FSC-W
%       gate3: SSC-H vs. SSC-W
%
%   Example:
%       my_morpho_gate = createMorphoGate('s_FT_NoDNA.fcs');
%
%   See also createGate


% check if morphogate exists
%first check if metadata folder has been created
if exist('metadata','dir')~=7 %checks entire path
% if exist([pwd 'metadata'],'dir')~=7 %checks current dir
    mkdir('metadata')
end
if exist('metadata/MorphoGate','dir')~=7 %checks entire path
% if exist([pwd 'metadata/MorphoGate'],'dir')~=7 %checks current dir
    mkdir('metadata/MorphoGate')
end
%check if mophogate for this file has been created
%----->update below made 9/26/2018 % gate_base_name = fileName(1:end-4);
[filepath,name,ext] = fileparts(fileName);
gate_base_name = name;
if exist(['metadata/MorphoGate/MorphoGate_' gate_base_name '.mat'],'file')==2
    morpho = load(['metadata/MorphoGate/MorphoGate_' gate_base_name '.mat']);
    morpho_gate = morpho.gates;
    disp('... using MorphoGate in metadata folder...')
else
        
    %P1
    p1chs = {'FSC-A', 'SSC-A'};
    p1chsIDs = getChannelNum(fileName,p1chs);

    
%     P1data = getflowdata(fileName, p1chsIDs);
    gates(1) = createGate(fileName, p1chsIDs,'semilogy');
    savefig('metadata/MorphoGate/P1')
    
    %P2
    p2chs = {'FSC-W', 'FSC-H'};
    try 
        p2chsIDs = getChannelNum(fileName,p2chs);
    
    
    %     P2data = getflowdata(fileName, p2chsIDs, gates);
        gates(2) = createGate(fileName,p2chsIDs,gates,'linear');
        savefig('metadata/MorphoGate/P2')
    catch
    end
    
    %P3
    p3chs = {'SSC-W', 'SSC-H'};
    try
        p3chsIDs = getChannelNum(fileName,p3chs);


    %     P3data = getflowdata(fileName, p3chsIDs, gates);
        gates(3) = createGate(fileName, p3chsIDs,gates,'linear');
        savefig('metadata/MorphoGate/P3')
    catch
    end
    morpho_gate = gates;
    save(['metadata/MorphoGate/MorphoGate_' gate_base_name '.mat'],'gates')
end


end
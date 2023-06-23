function data_gated = applyGate(data, gate)
% applies a certain gate struct to a specified sample

% allow any number of gate structs
%check how big gate struct is
indices = true(size(data,1),1);
numel(gate)
for g = numel(gate)

    channels = gate(g).chs;
    position = gate(g).pos;
    xdat = data(:,channels(1));
    ydat = data(:,channels(2));
    indices= indices & inpolygon(xdat,ydat,position(:,1),position(:,2));
    
end

data_gated = data(indices,:);


end
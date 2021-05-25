function show_3d(r0,r_on)
%% visualization 

    figure;
    % r1 = r0;
    r1 = r0(r_on,:);
    scatter3(r1(:,1),r1(:,2),r1(:,3),30,'MarkerEdgeColor','k', 'MarkerFaceColor',[1 0.9 0]); 
    axis equal; axis tight;
    rotate3d on;

end


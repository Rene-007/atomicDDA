function show_2d(r0,r_on,lattice)
%% visualization 

    z0 = 0;
    z1 = 1;
    z2 = -1;
    z = r0(:,3)/(lattice.spacing*0.816496580927);
    z0_plane = not(logical(z - z0));
    z1_plane = not(logical(z - z1));
    z2_plane = not(logical(z - z2));

    figure;
    tiledlayout('flow');
    nexttile
    scatter(r0(z1_plane,1),r0(z1_plane,2),45*r_on(z1_plane)+0.1,'MarkerEdgeColor','k', 'MarkerFaceColor',[0.2 0.93 0.2]); hold on;
    scatter(r0(z0_plane,1),r0(z0_plane,2),90*r_on(z0_plane)+0.1,'MarkerEdgeColor','k', 'MarkerFaceColor',[1 0.9 0]); hold on;
    scatter(r0(z2_plane,1),r0(z2_plane,2),45*r_on(z2_plane)+0.1,'MarkerEdgeColor','k', 'MarkerFaceColor',[1 00 0]);
    axis equal; axis tight;
    nexttile
    scatter(r0(:,1),r0(:,3),30*r_on+0.1,'MarkerEdgeColor','k', 'MarkerFaceColor',[1 0.9 0]);
    axis equal; axis tight;
    nexttile
    scatter(r0(:,2),r0(:,3),90*r_on+0.1,'MarkerEdgeColor','k', 'MarkerFaceColor',[1 0.9 0]);
    axis equal; axis tight;
    nexttile
    scatter3(r0(:,1),r0(:,2),r0(:,3),30*r_on+0.1,'MarkerEdgeColor','k', 'MarkerFaceColor',[1 0.9 0]); 
    axis equal; axis tight;

end


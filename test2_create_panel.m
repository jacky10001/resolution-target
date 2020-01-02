clc,clear

% unit: mm
dx = 0.01 ;
N = 5000 ;

tic
cnt = 0 ;
for tG=-2:-1
    if mod(cnt,2) == 0
        tw_start = 1 ;
        tl_start = 1 ;
        for tE=[2:6,1]
            [lw,ll] = compute_width(tG,tE,dx) ;
            tt = draw_LP(lw, ll);
            [m,n] = size(tt) ;
            if tE == 1
                target(tw_start-m:tw_start-1,N-n:N-1) = tt ;
            else
                target(tw_start:tw_start+m-1,tl_start:tl_start+n-1) = tt ;
                if tE == 6
                    tw_start = tw_start + ll ;
                else
                    tw_start = tw_start + ll + 2*lw ;
                end
            end
        end
    else
        tw_start = 1 ;
        tl_start = N ;
        for tE=1:6
            [lw,ll] = compute_width(tG,tE,dx) ;
            tt = draw_LP(lw, ll);
            [m,n] = size(tt) ;
            target(tw_start:tw_start+m-1,tl_start-n:N-1) = tt ;
            tw_start = tw_start + ll + 2*lw ;
        end
    end
    cnt = cnt + 1 ;
end
toc

figure(1),imagesc(target),colormap gray,axis image
imwrite(target, 'image\target_02.jpg')


function [lw,ll] = compute_width(tG,tE,dx)
    lp = 2^(tG+(tE-1)/6) ;
    lw = 1/2/lp ;
    lw = round( lw/dx ) ;
    ll = lw * 5 ;
end

function lp = draw_LP(lp_width,lp_length)
    lp_w = 1 ;
    lp_l = 1 ;
    for i=1:5
        if mod(i,2) == 1
            for dd = lp_w:lp_w+lp_width
                lp(dd,lp_l:lp_length) = 1 ;
            end
        end
        lp_w = lp_w + lp_width ;
    end
    lp_w = lp_length + 2*lp_width ;  % 一組線對間隔 (X軸)
    for i=6:10
        if mod(i,2) == 0
            for dd = lp_w:lp_w+lp_width
                lp(lp_l:lp_length,dd) = 1 ;
            end
        end
        lp_w = lp_w + lp_width ;
    end
end
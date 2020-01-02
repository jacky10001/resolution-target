clc,clear,close all

% unit: mm
dx = 0.01 ;
%%
N = 19156 ;
tic; t0 = create_panel(-4,N,dx) ; toc;

N = 4789 ;
tic; t1 = create_panel(-2,N,dx) ; toc;

N = 1198 ;
tic; t2 = create_panel(0,N,dx) ; toc;

N = 300 ;
tic; t3 = create_panel(2,N,dx) ; toc;
%%
target = t0 ;

[yc,xc] = size(t1) ; tune_x = 11280 ; tune_y = 9400 ;
target(...
    round(tune_y-yc/2+1):round(tune_y+yc/2), ...
    round(tune_x-xc/2+1):round(tune_x+xc/2)) = t1 ;

[yc,xc] = size(t2) ; tune_x = 11800 ; tune_y = 9400 ;
target(...
    round(tune_y-yc/2+1):round(tune_y+yc/2), ...
    round(tune_x-xc/2+1):round(tune_x+xc/2)) = t2 ;

[yc,xc] = size(t3) ; tune_x = 11950 ; tune_y = 9400 ;
target(...
    round(tune_y-yc/2+1):round(tune_y+yc/2), ...
    round(tune_x-xc/2+1):round(tune_x+xc/2)) = t3 ;

figure(9),imagesc(target),colormap gray,axis image

imwrite(target, 'image\target_03.jpg')
%%
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

function target = create_panel(start_group,board_width,dx)
    cnt = 0 ;
    for tG=start_group:start_group+1
        if mod(cnt,2) == 0
            tw_start = 1 ;
            tl_start = 1 ;
            for tE=[2:6,1]
                [lw,ll] = compute_width(tG,tE,dx) ;
                tt = draw_LP(lw, ll);
                [m,n] = size(tt) ;
                if tE == 1
                    target(tw_start-m:tw_start-1,board_width-n:board_width-1) = tt ;
                else
                    target(tw_start:tw_start+m-1,tl_start:tl_start+n-1) = tt ;
                    if tE == 6
                        tw_start = tw_start + ll ;
                    else
                        tw_start = tw_start + ll + 2*lw ;  % 一組線對間隔 (Y軸)
                    end
                end
            end
        else
            tw_start = 1 ;
            tl_start = board_width ;
            for tE=1:6
                [lw,ll] = compute_width(tG,tE,dx) ;
                tt = fliplr( draw_LP(lw, ll) ) ;
                [m,n] = size(tt) ;
                target(tw_start:tw_start+m-1,tl_start-n:board_width-1) = tt ;
                tw_start = tw_start + ll + 2*lw ;
            end
        end
        cnt = cnt + 1 ;
    end
end
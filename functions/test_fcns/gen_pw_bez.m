function [ plt,tvec,cltp ] = gen_pw_bez( all_cltp,segs,tratio,N_pts)
%plt_bez Plot piecewise bezier curve from control points
%   cltp    - control points
%   bcps    - number of cltps per segment

prev_ts = 0;
bcps = length(all_cltp)/segs;

plt=cell(1,segs);
tvec=cell(1,segs);
cltp=cell(1,segs);

for k = 0:(segs-1)
  ts = prev_ts+tratio(k+1);
  tvec{k+1} = linspace(prev_ts,ts, N_pts);
  cltp{k+1} = all_cltp(k*bcps+1:bcps*(k+1),:);
  plt{k+1} = gen_bezier(tvec{k+1}',cltp{k+1});
  prev_ts = ts;
end

end


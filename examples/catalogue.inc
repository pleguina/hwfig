% Shared body of the style catalogue (styles.tex, styles_more.tex).
% Expects \pal to hold the palette name.
\newcommand\stylecap[2]{\node[font=\scriptsize\ttfamily,text=hwtext!70!hwpaper,anchor=north] at ($(#1.south)+(0,-0.12)$) {#2};}
\newcommand\wirecap[2]{\node[font=\scriptsize\ttfamily,text=hwtext!70!hwpaper] at (#1) {#2};}
\newcommand\catalogue{%
\begin{tikzpicture}[hw,hwcanvas]
  \node[font=\normalsize\bfseries,anchor=west] at (-0.9,1.15) {\texttt{\textbackslash hwpalette\{\pal\}}};
  % row 1: dataflow roles
  \node[runtime] (a) at (0,0) {$x_i$};               \stylecap{a}{runtime}
  \node[ctime] (b) at (1.8,0) {$W$};                 \stylecap{b}{ctime}
  \node[hlsbox] (c) at (3.9,0) {kernel};             \stylecap{c}{hlsbox}
  \node[qbox] (d) at (6.1,0) {shift+sat8};           \stylecap{d}{qbox}
  \node[op] (e) at (7.7,0) {$+$};                    \stylecap{e}{op}
  \node[mux] (f) at (8.8,0) {};                      \stylecap{f}{mux}
  \node[demux] (g) at (9.8,0) {};                    \stylecap{g}{demux}
  \node[ctrl] (h) at (11.4,0) {FSM};                 \stylecap{h}{ctrl}
  % row 2: memory
  \node[mem] (i) at (0.3,-1.9) {buffer};             \stylecap{i}{mem}
  \node[bram] (j) at (2.3,-1.9) {BRAM};              \stylecap{j}{bram}
  \node[uram] (k) at (4.0,-1.9) {URAM};              \stylecap{k}{uram}
  \node[fifo] (l) at (5.9,-1.9) {stream};            \stylecap{l}{fifo}
  \node[reg] (m) at (7.5,-1.9) {};                   \stylecap{m}{reg / ff}
  \node[extmem] (n) at (9.0,-1.9) {DDR4};            \stylecap{n}{extmem}
  \node[lut] (o) at (10.6,-1.9) {LUT};               \stylecap{o}{lut}
  \node[dsp] (p) at (11.9,-1.9) {$a\times b$};       \stylecap{p}{dsp}
  % row 3: system
  \node[cpu] (q) at (0.3,-3.9) {PS\\A72};            \stylecap{q}{cpu}
  \node[host] (r) at (2.6,-3.9) {Host};              \stylecap{r}{host}
  \node[xbar,minimum height=1.2cm] (s) at (4.3,-3.9) {\rotatebox{90}{AXI}}; \stylecap{s}{xbar}
  \node[router] (t) at (5.5,-3.9) {R};               \stylecap{t}{router}
  \node[pe] (u) at (6.6,-3.9) {PE};                  \stylecap{u}{pe}
  \node[aie] (v) at (7.8,-3.9) {AIE};                \stylecap{v}{aie}
  \node[cdc] (w) at (9.0,-3.9) {};                   \stylecap{w}{cdc}
  \node[port] (x) at (9.9,-3.9) {};                  \stylecap{x}{port}
  \node[chip,minimum width=1.9cm,minimum height=1.2cm] (y) at (11.6,-3.9) {die}; \stylecap{y}{chip}
  % row 4: flow, FSM, ML and annotation shapes
  \node[term] (ta) at (0.1,-5.9) {start};            \stylecap{ta}{term}
  \node[decision] (tb) at (2.0,-5.9) {valid?};       \stylecap{tb}{decision}
  \node[state] (tc) at (3.8,-5.9) {IDLE};            \stylecap{tc}{state}
  \node[accstate] (td) at (5.2,-5.9) {RUN};          \stylecap{td}{accstate}
  \node[buf] (te) at (6.5,-5.9) {};                  \stylecap{te}{buf}
  \node[net] (tf) at (8.2,-5.9) {10 GbE};            \stylecap{tf}{net}
  \node[neuron] (tg) at (9.8,-5.9) {};               \stylecap{tg}{neuron}
  \node[badge] (th) at (10.7,-5.9) {1};              \stylecap{th}{badge}
  \node[hlsbox,stack,minimum width=1.2cm] (ti) at (12.0,-5.9) {$\times 18$}; \stylecap{ti}{stack}
  % row 5: wires
  \draw[arr] (-0.6,-7.7) -- (0.7,-7.7);   \wirecap{0.05,-8.05}{arr}
  \draw[darr] (1.3,-7.7) -- (2.6,-7.7);   \wirecap{1.95,-8.05}{darr}
  \draw[hot] (3.2,-7.7) -- (4.5,-7.7);    \wirecap{3.85,-8.05}{hot}
  \draw[bus] (5.1,-7.7) -- (6.6,-7.7) pic[pos=.4]{buswidth=512}; \wirecap{5.85,-8.05}{bus}
  \draw[biarr] (7.2,-7.7) -- (8.5,-7.7);  \wirecap{7.85,-8.05}{biarr}
  \draw[ctlarr] (9.1,-7.7) -- (10.4,-7.7); \wirecap{9.75,-8.05}{ctlarr}
  \draw[link] (11.0,-7.7) -- (12.5,-7.7); \wirecap{11.75,-8.05}{link}
  % row 6: labels, frames, annotations
  \draw[arr] (-0.6,-9.2) -- (0.9,-9.2) node[lbl,midway,above]{AXI4-S};  \wirecap{0.15,-9.55}{lbl}
  \draw[arr] (1.6,-9.2) -- (3.1,-9.2) node[lblbox,midway]{AXI};         \wirecap{2.35,-9.55}{lblbox}
  \draw[arr] (3.8,-9.2) -- (4.6,-9.2) node[dot] (dt) {} -- (5.4,-9.2);
  \draw[arr] (dt) |- (5.4,-8.85);                                        \wirecap{4.6,-9.55}{dot}
  \draw[brace] (6.1,-9.3) -- (7.5,-9.3) node[lbl,midway,above=5pt]{8 bit}; \wirecap{6.8,-9.55}{brace}
  \node[note,anchor=center] at (8.7,-9.1) {latency\\budget};             \wirecap{8.7,-9.55}{note}
  \node[group,minimum width=1.2cm,minimum height=0.5cm,label={[grouplabel]above:PL}] at (10.3,-9.2) {}; \wirecap{10.3,-9.65}{group}
  \node[clkdomain,minimum width=1.2cm,minimum height=0.5cm,inner sep=0pt] at (12.0,-9.2) {}; \wirecap{12.0,-9.65}{clkdomain}
\end{tikzpicture}}

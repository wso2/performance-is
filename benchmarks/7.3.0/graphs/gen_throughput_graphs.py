"""Generate 7.3.0 throughput-vs-concurrency graphs — 9 scenarios × 2 concurrency
ranges (50-500, 50-3000) = 18 PNGs, saved as <scenario>/50_500_throughput.png and
<scenario>/50_3000_throughput.png next to this script.

Throughput is the value of the primary bottleneck step (same row the summary
tables use): complete flows/sec for multi-step flows, requests/sec for
single-step grants. Styled to match generate_graphs.py (the 95th-percentile
response-time graphs).

The 50-500 charts carry five configurations; Two Node 2 Core was only measured
over that range, so the 50-3000 charts stay on the four 4 Core configurations.
A chart whose configurations differ by more than 8x at the same concurrency is
drawn on a log y-axis, which its axis label states."""
import os
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

# ── colour / style constants (identical to generate_graphs.py) ────────────────
# Two Node 2 Core leads the list in purple with a distinct marker; the four
# 4 Core entries keep the colours and markers they have always had.
TWO_CORE  = "Two Node 2 Core"
CONFIGS   = [TWO_CORE, "Single Node 4 Core", "Two Node 4 Core", "Three Node 4 Core", "Four Node 4 Core"]
COLORS    = ["#9467bd", "#1f77b4", "#ff7f0e", "#2ca02c", "#d62728"]
MARKERS   = ["v", "o", "s", "^", "D"]
# Two Node 2 Core was only measured over 50-500, so it is drawn on the low-range
# charts alone; the 50-3000 charts stay on the four 4 Core configurations.
CONFIGS_LOW = CONFIGS
CONFIGS_ALL = CONFIGS[1:]
CU_ALL    = [50, 100, 150, 300, 500, 750, 1000, 1500, 2000, 2500, 3000]
RANGES    = {"50_500": [50, 100, 150, 300, 500], "50_3000": CU_ALL}

GRAPH_DIR = os.path.dirname(os.path.abspath(__file__))

NA = None  # short alias for unavailable data points

# A chart whose configurations differ by more than this multiple *at the same
# concurrency* is drawn on a log y-axis — otherwise the four 4 Core series
# collapse into one flat band against a single 2 Core spike. The test is
# deliberately per-concurrency: a series that simply climbs with the x sweep
# must stay linear, or a straight line is drawn as a false saturation curve.
LOG_RATIO = 8.0


def spread(cu_list, data_by_config, configs):
    """Largest max/min ratio across configurations at a single concurrency."""
    worst = 1.0
    for cu in cu_list:
        i = CU_ALL.index(cu)
        col = [data_by_config[c][i] for c in configs
               if c in data_by_config and data_by_config[c][i] is not None]
        if len(col) > 1 and min(col) > 0:
            worst = max(worst, max(col) / min(col))
    return worst


def apply_log_scale(ax, ylabel):
    """Log y-axis, with the 1-2-3-5 decade steps labelled as plain numbers so
    values stay readable instead of leaving a single labelled decade tick."""
    ax.set_yscale("log")
    ax.yaxis.set_minor_locator(matplotlib.ticker.LogLocator(subs=(2.0, 3.0, 5.0)))
    for set_fmt in (ax.yaxis.set_major_formatter, ax.yaxis.set_minor_formatter):
        set_fmt(matplotlib.ticker.FuncFormatter(
            lambda v, _pos: f"{v:g}" if v >= 1 else f"{v:.1f}"))
    return f"{ylabel} — log scale"


def make_plot(scenario_dir, filename, cu_list, data_by_config, configs, ylabel):
    os.makedirs(scenario_dir, exist_ok=True)
    fig, ax = plt.subplots(figsize=(10, 6))

    for cfg, color, marker in zip(CONFIGS, COLORS, MARKERS):
        if cfg not in configs or cfg not in data_by_config:
            continue
        raw = data_by_config[cfg]
        xs, ys = [], []
        for cu in cu_list:
            v = raw[CU_ALL.index(cu)]
            if v is not None:
                xs.append(cu)
                ys.append(v)
        if xs:
            ax.plot(xs, ys, label=cfg, color=color, marker=marker,
                    linewidth=2, markersize=6)

    ax.set_xlabel("Concurrent Users", fontsize=12)
    if spread(cu_list, data_by_config, configs) > LOG_RATIO:
        ylabel = apply_log_scale(ax, ylabel)
    ax.set_ylabel(ylabel, fontsize=12)
    ax.legend(fontsize=10, loc="upper left")
    ax.grid(True, linestyle="--", alpha=0.6)
    ax.set_xticks(cu_list)
    plt.tight_layout()
    out = os.path.join(scenario_dir, filename)
    plt.savefig(out, dpi=150)
    plt.close(fig)
    print(f"  saved → {out}")


def gen(folder, unit, data):
    """data: dict cfg → list[11] of float|None (order matches CU_ALL)"""
    ylabel = f"Throughput ({unit})"
    d = os.path.join(GRAPH_DIR, folder)
    for key, cu_list in RANGES.items():
        configs = CONFIGS_LOW if key == "50_500" else CONFIGS_ALL
        make_plot(d, f"{key}_throughput.png", cu_list, data, configs, ylabel)


FLOWS = "Complete Flows/sec"
REQS = "Requests/sec"

# ── throughput of the bottleneck step per config (CU_ALL order) ───────────────

gen("OIDC_Auth_Code_Grant_Redirect_With_Consent", FLOWS, {
    "Two Node 2 Core":    [6.2, 12.32, 18.56, 37.06, 61.77, NA, NA, NA, NA, NA, NA],
    "Single Node 4 Core": [6.2, 12.39, 18.59, 37.12, 61.79, 92.96, 123.54, 153.32, 145.35, 146.22, 149.66],
    "Two Node 4 Core":    [6.22, 12.43, 18.57, 37.1, 61.89, 92.84, 123.35, 185.36, 246.53, 306.21, 312.88],
    "Three Node 4 Core":  [6.14, 12.33, 18.5, 37.02, 61.63, 92.51, 123.54, 184.81, 246.46, 306.96, 364.5],
    "Four Node 4 Core":   [6.22, 12.4, 18.58, 37.15, 61.53, 92.42, 123.39, 184.84, 246.47, 307.11, 364.87],
})

gen("OIDC_Auth_Code_Grant_Redirect_Without_Consent", FLOWS, {
    "Two Node 2 Core":    [8.2, 16.43, 24.64, 49.18, 80.48, NA, NA, NA, NA, NA, NA],
    "Single Node 4 Core": [8.27, 16.44, 24.68, 49.5, 82.38, 123.62, 163.82, 150.97, 141.15, 151.32, 149.32],
    "Two Node 4 Core":    [8.26, 16.48, 24.63, 49.52, 82.57, 123.44, 165.18, 246.72, 325.14, 308.32, 298.02],
    "Three Node 4 Core":  [8.17, 16.4, 24.65, 49.43, 82.15, 123.25, 164.23, 246.2, 327.18, 397.5, 420.06],
    "Four Node 4 Core":   [8.2, 16.46, 24.75, 49.52, 82.2, 123.1, 164.11, 246.16, 326.79, 399.42, 420.89],
})

gen("OIDC_Auth_Code_Grant_Redirect_Without_Consent_Retrieve_User_Attributes", FLOWS, {
    "Two Node 2 Core":    [8.18, 16.43, 24.63, 49.18, 80.3, NA, NA, NA, NA, NA, NA],
    "Single Node 4 Core": [8.23, 16.47, 24.68, 49.41, 82.29, 123.46, 163.25, 157.14, 141.67, 150.75, 147.08],
    "Two Node 4 Core":    [8.26, 16.41, 24.6, 49.55, 82.28, 123.78, 164.99, 246.46, 325.19, 300.5, 299.71],
    "Three Node 4 Core":  [8.2, 16.4, 24.7, 49.59, 82.16, 123.28, 164.27, 246.04, 327.78, 399.73, 420.67],
    "Four Node 4 Core":   [8.23, 16.51, 24.86, 49.3, 81.98, 123.31, 164.24, 246.37, 327.58, 399.69, 417.7],
})

gen("OIDC_Auth_Code_Grant_Redirect_Without_Consent_Retrieve_User_Attributes_Groups_and_Roles", FLOWS, {
    "Two Node 2 Core":    [8.19, 16.43, 24.67, 49.23, 79.98, NA, NA, NA, NA, NA, NA],
    "Single Node 4 Core": [8.27, 16.46, 24.79, 49.57, 82.4, 123.37, 163.21, 139.08, 146.57, 141.69, 137.44],
    "Two Node 4 Core":    [8.23, 16.52, 24.76, 49.53, 82.45, 123.67, 164.78, 246.79, 327.38, 320.09, 304.47],
    "Three Node 4 Core":  [8.26, 16.46, 24.68, 49.45, 82.13, 123.08, 164.21, 246.07, 327.35, 397, 414.17],
    "Four Node 4 Core":   [8.19, 16.51, 24.72, 49.48, 82.07, 123.22, 164.06, 246.26, 327.58, 398.59, 415.8],
})

gen("SAML2_SSO_Redirect_Binding", FLOWS, {
    "Two Node 2 Core":    [8.26, 16.59, 24.72, 49.48, 82.58, NA, NA, NA, NA, NA, NA],
    "Single Node 4 Core": [8.21, 16.46, 24.87, 49.58, 82.31, 123.98, 164.9, 228.96, 214.06, 234.48, 229.55],
    "Two Node 4 Core":    [8.31, 16.55, 24.86, 49.79, 82.27, 123.55, 164.84, 247.16, 328.42, 408.7, 479.83],
    "Three Node 4 Core":  [8.31, 16.47, 24.77, 49.77, 82.43, 123.43, 164.4, 246.03, 327.7, 408.2, 481.34],
    "Four Node 4 Core":   [8.25, 16.56, 24.79, 49.54, 82.22, 123.49, 164.37, 246.14, 327.6, 408.25, 481.87],
})

gen("App_Native_Authentication", FLOWS, {
    "Two Node 2 Core":    [8.33, 16.42, 24.55, 49.12, 80.19, NA, NA, NA, NA, NA, NA],
    "Single Node 4 Core": [8.28, 16.48, 24.7, 49.51, 82.43, 123.35, 146.61, 141.12, 137.55, 137.04, 137.82],
    "Two Node 4 Core":    [8.3, 16.54, 24.66, 49.47, 82.4, 123.43, 164.78, 246.54, 312.61, 293.32, 286.96],
    "Three Node 4 Core":  [8.21, 16.39, 24.73, 49.41, 82.05, 123.25, 164.32, 246.01, 327.65, 398.66, 412.67],
    "Four Node 4 Core":   [8.29, 16.45, 24.61, 49.4, 82.29, 123.44, 164.14, 246.65, 327.96, 399.11, 414.2],
})

gen("Token_Exchange_Grant", REQS, {
    "Two Node 2 Core":    [458.58, 367.84, 354.06, 344.86, 335.51, NA, NA, NA, NA, NA, NA],
    "Single Node 4 Core": [492.38, 475.99, 468.43, 454.03, 454.53, 447.55, 440.2, 421.77, 437.69, 442.26, 427.69],
    "Two Node 4 Core":    [714.29, 768.87, 819.55, 846.67, 888.77, 871.43, 882.4, 862.57, 805.03, 871.33, 845.24],
    "Three Node 4 Core":  [825.92, 911.09, 961.73, 1059.51, 1090.21, 1106.33, 1071.91, 1077.1, 1559.49, 1650.79, 1552.65],
    "Four Node 4 Core":   [853.73, 897.57, 1019.76, 1171.01, 1479.01, 1462.4, 1459.3, 1357.01, 1954.81, 1855.25, 1818.84],
})

gen("Client_Credentials_Grant_Type", REQS, {
    "Two Node 2 Core":    [905.66, 754.67, 752.65, 710.08, 681.38, NA, NA, NA, NA, NA, NA],
    "Single Node 4 Core": [1084.13, 1056.18, 1023.38, 990.67, 970.82, 836.79, 1009.93, 993.18, 971.99, 939.48, 818.55],
    "Two Node 4 Core":    [1750.07, 1744.6, 1896.92, 1739.69, 1868.69, 1670.84, 1849.52, 1827.82, 1797.86, 1795.96, 1775.21],
    "Three Node 4 Core":  [2538.89, 2627.19, 2398.75, 2638.63, 2553.6, 2491.09, 2579.61, 2635.45, 2964.64, 2919.44, 2886.31],
    "Four Node 4 Core":   [2856.2, 2927.64, 2949.31, 2981.62, 3014.67, 3133.25, 2898.68, 2907.15, 3454.13, 3390.89, 3338.06],
})

gen("OIDC_Password_Grant_Type", REQS, {
    "Two Node 2 Core":    [416.41, 328.42, 327.7, 320.14, 293.44, NA, NA, NA, NA, NA, NA],
    "Single Node 4 Core": [457.94, 430.68, 400.1, 388.98, 401.99, 388.34, 396.16, 394.49, 392.23, 380.97, 386.57],
    "Two Node 4 Core":    [708.97, 752.24, 778.25, 772.03, 793.72, 777.74, 762.26, 691.45, 762.22, 747.34, 672.99],
    "Three Node 4 Core":  [858.93, 953.06, 1002.8, 1099.88, 1166.76, 1163.33, 1131.35, 1139.62, 1774.08, 1710.47, 1744.98],
    "Four Node 4 Core":   [934.63, 1043.8, 1089.76, 1232.87, 1551.69, 1538.17, 1342.39, 1501.48, 2093.38, 1916.33, 1893.84],
})

print("\nAll throughput graphs generated.")

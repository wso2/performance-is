"""Generate 7.3.0 95th-percentile response-time graphs — 9 scenarios × 2
concurrency ranges (50-500, 50-3000) = 18 PNGs, saved as <scenario>/50_500_lines.png
and <scenario>/50_3000_lines.png next to this script.

The 50-500 charts carry five configurations; Two Node 2 Core was only measured
over that range, so the 50-3000 charts stay on the four 4 Core configurations.
A 50-500 chart whose configurations differ by more than 8x at the same
concurrency is drawn on a log y-axis, which its axis label states; the 50-3000
charts stay linear."""
import os
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

# ── colour / style constants ────────────────────────────────────────────────
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
CU_LOW    = [50, 100, 150, 300, 500]

GRAPH_DIR = os.path.dirname(os.path.abspath(__file__))

# A 50-500 chart whose configurations differ by more than this multiple *at the
# same concurrency* is drawn on a log y-axis — otherwise the four 4 Core series
# collapse into one flat band against a single 2 Core spike. The test is
# deliberately per-concurrency: a series that simply climbs with the x sweep
# must stay linear, or a straight line is drawn as a false saturation curve.
#
# The rule is scoped to the low-range charts, which are the ones carrying the
# 2 Core series. The published 50-3000 charts stay linear as they have always
# been, so that adding 2N2C does not silently restyle them.
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


# ── helper ───────────────────────────────────────────────────────────────────
def make_plot(scenario_dir, filename, cu_list, data_by_config, configs, allow_log,
              ylabel="95th Percentile of Response Time (ms)"):
    os.makedirs(scenario_dir, exist_ok=True)
    fig, ax = plt.subplots(figsize=(10, 6))

    for cfg, color, marker in zip(CONFIGS, COLORS, MARKERS):
        if cfg not in configs or cfg not in data_by_config:
            continue
        raw = data_by_config[cfg]
        xs, ys = [], []
        for cu in cu_list:
            idx = CU_ALL.index(cu)
            v = raw[idx]
            if v is not None:
                xs.append(cu)
                ys.append(v)
        if xs:
            ax.plot(xs, ys, label=cfg, color=color, marker=marker,
                    linewidth=2, markersize=6)

    ax.set_xlabel("Concurrent Users", fontsize=12)
    if allow_log and spread(cu_list, data_by_config, configs) > LOG_RATIO:
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


def gen(folder, title, data):
    """data: dict cfg → list[11] of float|None (order matches CU_ALL)"""
    d = os.path.join(GRAPH_DIR, folder)
    make_plot(d, "50_500_lines.png",  CU_LOW, data, CONFIGS_LOW, allow_log=True)
    make_plot(d, "50_3000_lines.png", CU_ALL, data, CONFIGS_ALL, allow_log=False)


# ── data: 95th percentile of the *bottleneck step* per config (CU_ALL order)
# None = Sheet not found / data unavailable

NA = None   # short alias

# ────────────────────────────────────────────────────────────────────────────
# 1. OIDC Auth Code Grant Redirect With Consent  ─  Step 4: Consent Approval
# ────────────────────────────────────────────────────────────────────────────
gen("OIDC_Auth_Code_Grant_Redirect_With_Consent", "OIDC Auth Code Grant – With Consent", {
    "Two Node 2 Core":    [12, 12, 12, 13, 14, NA, NA, NA, NA, NA, NA],
    "Single Node 4 Core": [11, 11, 11, 11, 13, 14, 17, 835, 3247, 4607, 6015],
    "Two Node 4 Core":    [11, 11, 11, 11, 11,  12, 13,  15,   19,   44,  839],
    "Three Node 4 Core":  [14, 13, 13, 13, 15,  16, 16,  17,   20,   36,   76],
    "Four Node 4 Core":   [13, 12, 12, 12, 15,  16, 16,  17,   19,   26,   86],
})

# ────────────────────────────────────────────────────────────────────────────
# 2. OIDC Auth Code Grant Redirect Without Consent  ─  Step 2: Login
# ────────────────────────────────────────────────────────────────────────────
gen("OIDC_Auth_Code_Grant_Redirect_Without_Consent", "OIDC Auth Code Grant – Without Consent", {
    "Two Node 2 Core":    [33, 50, 44, 46, 437, NA, NA, NA, NA, NA, NA],
    "Single Node 4 Core": [33, 33, 27, 28, 35,  38,  80, 2463, 4735, 7391, 10239],
    "Two Node 4 Core":    [33, 33, 26, 26, 31,  28,  30,   42,   99, 1975,  4191],
    "Three Node 4 Core":  [38, 38, 32, 32, 42,  38,  39,   43,   58,  281,  1095],
    "Four Node 4 Core":   [37, 36, 30, 29, 42,  39,  39,   43,   54,  271,  1191],
})

# ────────────────────────────────────────────────────────────────────────────
# 3. OIDC Auth Code Grant Without Consent – User Attributes  ─  Step 2
# ────────────────────────────────────────────────────────────────────────────
gen("OIDC_Auth_Code_Grant_Redirect_Without_Consent_Retrieve_User_Attributes",
    "OIDC Auth Code Grant – Without Consent + User Attributes", {
    "Two Node 2 Core":    [35, 44, 44, 46, 435, NA, NA, NA, NA, NA, NA],
    "Single Node 4 Core": [28, 27, 27, 28, 30,  38,  79, 2127, 4607, 7615, 10367],
    "Two Node 4 Core":    [28, 26, 26, 26, 26,  28,  31,   43,  114, 2191,  4159],
    "Three Node 4 Core":  [34, 33, 32, 32, 37,  38,  37,   42,   52,   NA,  1079],
    "Four Node 4 Core":   [33, 30, 30, 29, 39,  38,  39,   43,   49,  305,    NA],
})

# ────────────────────────────────────────────────────────────────────────────
# 4. OIDC Auth Code Grant Without Consent – UA + Groups/Roles  ─  Step 2
# ────────────────────────────────────────────────────────────────────────────
gen("OIDC_Auth_Code_Grant_Redirect_Without_Consent_Retrieve_User_Attributes_Groups_and_Roles",
    "OIDC Auth Code Grant – Without Consent + UA + Groups/Roles", {
    "Two Node 2 Core":    [35, 45, 43, 46, 409, NA, NA, NA, NA, NA, NA],
    "Single Node 4 Core": [28, 28, 27, 28, 29,  39,  78, 2559, 4863, 7807, 11007],
    "Two Node 4 Core":    [27, 27, 26, 26, 27,  28,  31,   42,   77, 1751,  3839],
    "Three Node 4 Core":  [34, 33, 32, 32, 35,  36,  37,   42,   59,  297,  1047],
    "Four Node 4 Core":   [33, 32, 30, 29, 38,  39,  39,   42,   50,   NA,    NA],
})

# ────────────────────────────────────────────────────────────────────────────
# 5. SAML2 SSO Redirect Binding  ─  Step 2: IDP Login
# ────────────────────────────────────────────────────────────────────────────
gen("SAML2_SSO_Redirect_Binding", "SAML2 SSO Redirect Binding", {
    "Two Node 2 Core":    [34, 42, 41, 41, 45, NA, NA, NA, NA, NA, NA],
    "Single Node 4 Core": [32, 31, 31, 31, 32,  35,  41, 1463, 4047, 5599, 8575],
    "Two Node 4 Core":    [32, 32, 31, 31, 31,  31,  33,   38,   46,   73,  439],
    "Three Node 4 Core":  [41, 39, 39, 38, 48,  48,  49,   51,   56,   65,  351],
    "Four Node 4 Core":   [37, 34, 34, 33, 47,  47,  47,   50,   55,   58,  353],
})

# ────────────────────────────────────────────────────────────────────────────
# 6. App Native Authentication  ─  Step 2: Credential Submission
# ────────────────────────────────────────────────────────────────────────────
gen("App_Native_Authentication", "App Native Authentication", {
    "Two Node 2 Core":    [43, 58, 57, 61, 465, NA, NA, NA, NA, NA, NA],
    "Single Node 4 Core": [38, 37, 37, 38, 41,  56, 1175, 3791, 6719, 10623, 14783],
    "Two Node 4 Core":    [38, 37, 37, 36, 36,  38,   43,   71,  715,  3263,  5951],
    "Three Node 4 Core":  [46, 45, 44, 44, 53,  54,   55,   62,   80,    NA,  1535],
    "Four Node 4 Core":   [44, 42, 41, 40, 47,  49,   50,   53,   63,   391,  1839],
})

# ────────────────────────────────────────────────────────────────────────────
# 7. Token Exchange Grant Type
# ────────────────────────────────────────────────────────────────────────────
gen("Token_Exchange_Grant", "Token Exchange Grant Type", {
    "Two Node 2 Core":    [277, 755, 1175, 2415, 4127, NA, NA, NA, NA, NA, NA],
    "Single Node 4 Core": [153, 329, 511, 1063, 1759, 2671, 3471,  4991,  6175,  7167,  9023],
    "Two Node 4 Core":    [191, 275, 381,  811, 1615, 2399, 3247,  6047,  7103, 11839, 16319],
    "Three Node 4 Core":  [173, 293, 381,  699, 1591, 2319, 3151,  4351,  5887,  4735,  5919],
    "Four Node 4 Core":   [174, 257, 307,  489, 1423,   NA, 2847,  4255,  4543,  4255,  4991],
})

# ────────────────────────────────────────────────────────────────────────────
# 8. Client Credentials Grant Type
# ────────────────────────────────────────────────────────────────────────────
gen("Client_Credentials_Grant_Type", "Client Credentials Grant Type", {
    "Two Node 2 Core":    [147, 469, 751, 1679, 2495, NA, NA, NA, NA, NA, NA],
    "Single Node 4 Core": [  74,  138,  203,  429,  783, 1399, 1503, 2191, 3007, 4063, 4895],
    "Two Node 4 Core":    [  51,  194,  373,  819, 1295, 2143, 2223, 3071, 4159, 4831, 5599],
    "Three Node 4 Core":  [  35,  118,  243,  575,  951, 1679, 1983, 2735, 2367, 2191, 2175],
    "Four Node 4 Core":   [  25,   50,  126,  287,  385, 1311,  851, 1511, 2159, 1807, 1447],
})

# ────────────────────────────────────────────────────────────────────────────
# 9. OIDC Password Grant Type
# ────────────────────────────────────────────────────────────────────────────
gen("OIDC_Password_Grant_Type", "OIDC Password Grant Type", {
    "Two Node 2 Core":    [245, 675, 1039, 2207, 4079, NA, NA, NA, NA, NA, NA],
    "Single Node 4 Core": [ 157,  289,  455,  955, 1559, 2463, 3103, 4415, 5695, 7231,  8383],
    "Two Node 4 Core":    [ 177,  291,  421,  879, 1479, 2383, 3471, 7391, 9471, 8255, 18303],
    "Three Node 4 Core":  [ 182,  236,  297,  543, 1423, 2287, 3279, 5919, 4863, 7039,  6975],
    "Four Node 4 Core":   [ 183,  233,  303,  419, 1351, 2111,   NA, 5343, 6527, 5279,  6143],
})

print("\nAll graphs generated successfully.")

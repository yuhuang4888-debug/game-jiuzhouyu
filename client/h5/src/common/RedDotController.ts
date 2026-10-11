import { BaseController } from './BaseController';
import { RedKey, RedEvent } from './RedDotDefine';

export class RedDotController extends BaseController {
    //效率至上
    private static _ins: RedDotController;
    private m_redTree: { [k: string]: any[] } = {}; //红点树 父=[子，子,...]
    private m_redTreePar: { [k: string]: string } = {}; //反红点树 子=父
    private m_redCompTree: { [k: string]: Laya.UIComponent } = {}; //组件树  红点key = 组件
    private m_redState: { [k: string]: number } = {}; //红点状态 目前仅支持显示隐藏，支持数量显示
    constructor() {
        super();
        this.initRedTree();
    }

    public static get ins() {
        if (!RedDotController._ins) {
            RedDotController._ins = new RedDotController();
        }
        return RedDotController._ins;
    }

    add(key: string, parent: string) {
        let redTree = this.m_redTree;
        let redTreePar = this.m_redTreePar;

        if (!redTree[parent]) {
            redTree[parent] = [];
        }
        if (redTree[parent].indexOf(key) == -1) {
            redTree[parent].push(key);
            redTreePar[key] = parent;
        }
    }
    /**
     * 将红点变更绑定到组件上
     * @param key
     * @param comp 组件
     * @param txtComp 文字组件，因为分层的关系所以文字可能不会作为红点的子节点
     * @param update_now 是否立即更新
     */
    bind(key: keyof typeof RedKey, comp: Laya.UIComponent, txtComp?, update_now = true) {
        let m_redCompTree = this.m_redCompTree;
        m_redCompTree[key] = comp;
        comp['_lblchild'] = (comp.getChildByName('lblNum') as Laya.Text) || txtComp;
        if (update_now) {
            let state = this.get(key, false);
            this.setCompVisible(comp, state > 0);
            this.setLblChildNum(comp, state);
        }
        // 组件在destroy时自动解绑
        comp.onDestroy = this.unbind.bind(this, key);
    }
    unbind(key: keyof typeof RedKey, isUp = true) {
        let m_redCompTree = this.m_redCompTree;
        if (!m_redCompTree[key]) return;
        if (isUp) {
            this.setCompVisible(m_redCompTree[key], false);
        }
        m_redCompTree[key]['_lblchild'] = null;
        m_redCompTree[key].onDestroy = function () {};
        delete m_redCompTree[key];
    }
    del(key: keyof typeof RedKey) {
        let m_redTree = this.m_redTree;
        let m_redTreePar = this.m_redTreePar;
        let m_redState = this.m_redState;
        //释放子节点的关联
        m_redTree[key] &&
            m_redTree[key].forEach((p) => {
                delete m_redTreePar[p];
            });
        //释放本节点的关联
        delete m_redTree[key];
        delete m_redState[key];
        delete m_redTreePar[key];
        this.unbind(key);
    }
    up(key: string, state: number | boolean) {
        let redTreePar = this.m_redTreePar;
        let redCompTree = this.m_redCompTree;
        let redState = this.m_redState;
        if (typeof state === 'boolean') {
            state = state ? 1 : 0;
        }

        if (!redState[key]) {
            redState[key] = 0;
        }
        if (redState[key] == state) return;
        //红点状态发生变
        let dis = state - redState[key];
        redState[key] = state; //先更改红点状态
        this.Fire(RedEvent.RED_DOT_UPDATE, key, state);
        if (redCompTree[key]) {
            this.setLblChildNum(redCompTree[key], state);
            this.setCompVisible(redCompTree[key], state > 0);
        }
        if (state > 0) {
            //冒泡全显示
            let tp = redTreePar[key];
            while (tp) {
                //注意死循环
                if (!redState[tp]) {
                    redState[tp] = 0;
                }
                redState[tp] = redState[tp] + dis;
                if (redCompTree[tp]) {
                    this.setLblChildNum(redCompTree[tp], redState[tp]);
                    this.setCompVisible(redCompTree[tp], true);
                }
                this.Fire(RedEvent.RED_DOT_UPDATE, tp, redState[tp]);
                tp = redTreePar[tp];
            }
        } else {
            let tp = redTreePar[key];
            while (tp) {
                if (!redState[tp]) {
                    redState[tp] = 0;
                }
                //注意死循环
                //遍历父节点检测父节点是否有变动
                let before = this.get(tp as keyof typeof RedKey, false);
                let after = before + dis;
                if (redState[tp] != after) this.Fire(RedEvent.RED_DOT_UPDATE, tp, after);
                redState[tp] = after;
                if (redCompTree[tp]) {
                    this.setCompVisible(redCompTree[tp], after > 0);
                    this.setLblChildNum(redCompTree[tp], after);
                }
                tp = redTreePar[tp];
            }
        }
    }
    setLblChildNum(comp: Laya.UIComponent, state: number) {
        let lblNum = comp['_lblchild'] as Laya.Text;
        if (lblNum && !lblNum.destroyed) {
            lblNum.text = state + '';
        }
    }
    // 默认返回boolean类型，toBoolean==false时返回数量
    get<A>(key: keyof typeof RedKey, toBoolean?: A): A extends boolean ? number : boolean;
    get(key: keyof typeof RedKey, toBoolean = true) {
        let state = this.m_redState[key] || 0;
        if (toBoolean) {
            return (state || 0) > 0
        }
        return state
    }
    setCompVisible(comp, state: boolean) {
        comp && (comp.visible = state);
        comp['_lblchild'] && (comp['_lblchild'].visible = state);
    }
    //初始化红点树

    /**
     * 初始化红点树
     *
     * 不推荐树的深度超过5层
     *
     * 更新n次理论会消耗5n的时间复杂度
     *
     * ps
     * 推荐注册到模块入口,打开模块入口时自行更新详细模块的详细ui红点及其节点
     */

    initRedTree() {
        let redTree = this.m_redTree;
        let redTreePar = this.m_redTreePar;
        redTree[RedKey.EQUIP_STRENGTH] = [RedKey.EQUIP_STREN, RedKey.EQUIP_SMELT, RedKey.EQUIP_JEWEL, RedKey.EQUIP_WASH, RedKey.JEWEL_CRAVE_RED, RedKey.REFINEMENT_RED, RedKey.EQUIP_COMPOSITE, RedKey.EQUIP_ARMOR];
        redTree[RedKey.EQUIP_STREN] = [RedKey.EQUIP_STREN_MASTER];
        redTree[RedKey.REINCARNATION] = [];
        redTree[RedKey.PEP] = [RedKey.PEP_EQUIP, RedKey.PEP_STAR, RedKey.PEP_STREN];
        redTree[RedKey.LUNG_DOT] = [RedKey.LUNG_EXCHANGE, RedKey.LUNG_INSERT, RedKey.LUNG_STOVE_FIRST_OPEN, RedKey.LUNG_UPGRADE, RedKey.LUNG_STOVE_REWARD, RedKey.LUNG_SHOP];
        redTree[RedKey.BRIGHT_SEA] = [];
        redTree[RedKey.GOD] = [RedKey.GOD_ACTIVE, RedKey.GOD_LV, RedKey.GOD_STAGE, RedKey.GOD_STAR, RedKey.GOD_EQUIP, RedKey.GOD_QUICK_COM];
        redTree[RedKey.BAG] = [RedKey.HOLY_SEAL];
        redTree[RedKey.STAR_EQUIP_MAIN] = [RedKey.STAR_EQUIP, RedKey.GOD_COURT];
        redTree[RedKey.STAR_EQUIP] = [RedKey.STAR_EQUIP_MASTER, RedKey.STAR_EQUIP_COM, RedKey.STAR_EQUIP_DEVOUR];
        redTree[RedKey.LONG_LANG] = [RedKey.LONG_LANG_BETTER, RedKey.LONG_LANG_STREN, RedKey.LONG_LANG_DEV, RedKey.LONG_LANG_COMPOSITE];
        redTree[RedKey.BABY] = [RedKey.BABY_EQUIP_FOR, RedKey.BABY_EQUIP_IMP, RedKey.BABY_ILLU_RED];
        /**角色 */
        redTree[RedKey.ROLE] = [RedKey.ROLE_SKILL_STREN];
        redTree[RedKey.PRAY] = [];
        redTree[RedKey.SUIT] = [];

        redTree[RedKey.MEDAL] = [RedKey.MEDAL_COMMON, RedKey.MEDAL_STRENGTHEN];

        /**神装 */
        redTree[RedKey.GOD_EQUIPMENT] = [RedKey.GOD_EQUIPMENT_COMPOSITE, RedKey.GOD_EQUIPMENT_RING, RedKey.GOD_EQUIPMENT_RING_UPGRADE, RedKey.GOD_EQUIPMENT_BUILD];
        redTree[RedKey.MONBOOK] = [];
        redTree[RedKey.ILLU] = [RedKey.ILLU_HORSE, RedKey.ILLU_PEP, RedKey.ILLU_WING, RedKey.ILLU_HOLYDEVICE, RedKey.ILLU_ARTIFACT];
        redTree[RedKey.HORSE] = [RedKey.PEH_EQUIP, RedKey.PEH_STREN, RedKey.PEH_STAR];
        redTree[RedKey.MAIN_STRONGER] = [];
        redTree[RedKey.RUNE] = [RedKey.RUNE_UPGRADE, RedKey.RUNE_INSTERT, RedKey.RUNE_RESOLVE, RedKey.RUNE_AWAKE, RedKey.RUNE_SKILL];
        redTree[RedKey.DEMON] = [RedKey.DEMON_LEVEL, RedKey.DEMON_STAR, RedKey.DEMON_SKILL, RedKey.DEMON_ROTARY, RedKey.DEMON_PAINTING, RedKey.DEMON_TALENT, RedKey.DEMON_SHOP, RedKey.DEMON_LIFESKILL];
        redTree[RedKey.GOD_COURT] = [RedKey.GOD_COURT_UNLOCK, RedKey.GOD_COURT_DEVOUR, RedKey.GOD_COURT_UPSTAGE, RedKey.GOD_COURT_COM, RedKey.GOD_COURT_STRENGTH, RedKey.GOD_COURT_BETTER_EQUIP, RedKey.GOD_COURT_LOTTERY, RedKey.GOD_COURT_REWARD, RedKey.GOD_COURT_FIRST];
        redTree[RedKey.GHOST_WALK] = [RedKey.GHOST_WALK_CAN_FIGHT];
        redTree[RedKey.PARTNER_DUNGEON] = [RedKey.PARTNER_DUNGEON_CHALLENGE];
        redTree[RedKey.GUILD] = [
            RedKey.GUILD_INFO,
            RedKey.GUILD_MEMBER,
            RedKey.GUILD_REWARD_BOX,
        ];
        redTree[RedKey.GUILD_INFO] = [
            RedKey.GUILD_REDPACKET,
            RedKey.GUILD_APPLY_MARK,
            RedKey.GUILD_EVENING,
            RedKey.GUILD_GIFT,
            RedKey.GUILD_SKILL,
            RedKey.GUILD_GUARD,
            RedKey.GUILD_IDOL,
            RedKey.GUILD_EXCHANGE,
            RedKey.GUILD_MERGE,
            RedKey.GUILD_SHOP,
        ]
        redTree[RedKey.GUILD_SHOP] = [RedKey.GUILD_SHOP1];
        redTree[RedKey.GUILD_MEMBER] = [RedKey.GUILD_APPLY];
        redTree[RedKey.GUILD_REDPACKET] = [RedKey.GUILD_REDPACKET_RED_MARK];
        redTree[RedKey.GUILD_IDOL] = [RedKey.GUILD_IDOL_ACT, RedKey.GUILD_IDOL_AWAKEN, RedKey.GUILD_IDOL_RUNE];
        redTree[RedKey.GUILD_MERGE] = [RedKey.GUILD_MERGE_APPLY];
        redTree[RedKey.AUTO_BRUSH] = [RedKey.AUTO_BRUSH_STAGE, RedKey.MONSTER_SOAP];
        //构建子节点树
        for (let i in redTree) {
            for (let j in redTree[i]) {
                redTreePar[redTree[i][j]] = i;
            }
        }
    }
}

window['RedDotController'] = RedDotController;

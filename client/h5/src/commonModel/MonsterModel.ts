import { EventDispatcher } from '../util/EventDispatcher';
import { TMap } from '../util/TMap';
import { ErlangParser } from './../util/ErlangParser';
import { GoodsModel } from './GoodsModel';
import { Config } from "../common/Config"
import { RedDotController } from '../common/RedDotController';
import { RedKey } from '../common/RedDotDefine';

export interface ISConfSoap {
    soap_id: number,
    soap_name: string,
    condition: string,
    tv_ids: string
}

export interface ISConfSoapDebris {
    soap_id: number,
    debris_id: number,
    debris_name: string,
    cost: string,
    attr: string,
    model_id: string,
    condition: string
}

export interface IS2CMosterParam {
    soap_id: number;           // 古宝ID
    debris_list: {      // 古宝碎片列表
        debris_id: number     // 碎片ID
    }[];
}

/**
 * 祭典事件类型类
 */
export class MonsterModelEvent {
    static _cname = 'MonsterModelEvent';

    /**发送协议 */
    public static REQUEST_PROTO: string =
        MonsterModelEvent._cname + '_' + 'REQUEST_PROTO';
    /**初始化 */
    public static INIT: string =
        MonsterModelEvent._cname + '_' + 'INIT';
    /**激活碎片 */
    public static ACTIVALTION: string =
        MonsterModelEvent._cname + '_' + 'ACTIVALTION';
    /**页签选中 */
    public static TAB_SELECT: string =
        MonsterModelEvent._cname + '_' + 'TAB_SELECT';
    /**选中ICON*/
    public static SELECT_INDEX: string =
        MonsterModelEvent._cname + '_' + 'SELECT_INDEX';
    /**红点更新 */
    public static UPDATE_RED_DOT: string =
        MonsterModelEvent._cname + '_' + 'UPDATE_RED_DOT';

}

export class MonsterModel extends EventDispatcher {
    private static _instance: MonsterModel;
    public static GetInstance() {
        if (!MonsterModel._instance) {
            MonsterModel._instance = new MonsterModel();
        }
        return MonsterModel._instance;
    }

    private soapsMap: TMap<number, IS2CMosterParam>;
    private _combat: number = 0;
    private arrow_step = 1
    private red_state
    private refresh_time_id

    // 配置
    private confEnchantmentGuardSoap: any;
    private confEnchantmentGuardSoapDebris: any;
    private confEnchantmentGuardStageReward: any;



    public constructor() {
        super();
        this.soapsMap = new TMap<number, IS2CMosterParam>();
    }

    public get combat() {
        return this._combat;
    }

    public set combat(value) {
        this._combat = value;
    }

    public ClearSoapsBySoapMap() {
        this.soapsMap.clear();
    }

    public GetSoapsBySoapIdMap(soapId: number): IS2CMosterParam {
        return this.soapsMap.get(soapId);
    }

    public SetSoapsBySoapIdMap(value: IS2CMosterParam): void {
        return this.soapsMap.set(value.soap_id, value);
    }

    public GetSoapsMapValues(): IS2CMosterParam[] {
        return this.soapsMap.values;
    }

    public GetSoapsMapKeys(): string[] {
        return this.soapsMap.keys;
    }


    /**
     * 初始化配置
     */
    public InitConfig() {
        this.confEnchantmentGuardSoap = Config.PRELOAD_SERVER_CONFIG.config_enchantment_guard_soap;
        this.confEnchantmentGuardSoapDebris = Config.PRELOAD_SERVER_CONFIG.config_enchantment_guard_soap_debris;
        this.confEnchantmentGuardStageReward = Config.PRELOAD_SERVER_CONFIG.config_enchantment_guard_stage_reward;
    }

    /**
     * 获取可以展示的古宝id
     */
    public GetShowSoapIds(): number[] {
        let values: string[] = this.GetSoapsMapKeys();
        let ids: number[] = [];
        if (values.length > 0) {
            let curId: number = +values[values.length - 1];
            let keys: string[] = Object.keys(this.confEnchantmentGuardSoap);
            let act: boolean = this.GetActBySoapId(curId);
            let index: number = keys.indexOf(curId.toString());

            values = keys.slice(0, act ? index + 3 : index + 2);
            for (const iterator of values) {
                ids.push(+iterator);
            }
        } else {
            let keys: string[] = Object.keys(this.confEnchantmentGuardSoap).slice(0, 2);
            for (const iterator of keys) {
                ids.push(+iterator);
            }
        }

        return ids;


    }

    /**
     * 通过古宝id获取所有碎片id
     */
    public GetFragmentsAllBySoapId(soapId: number): number[] {
        if (!this.confEnchantmentGuardSoapDebris) {
            return [];
        }

        let keys: string[] = Object.keys(this.confEnchantmentGuardSoapDebris);
        let ids: number[] = [];
        for (const iterator of keys) {
            let conf: ISConfSoapDebris = this.confEnchantmentGuardSoapDebris[iterator];
            if (soapId === conf.soap_id) {
                ids.push(conf.debris_id);
            }
        }


        ids.sort((a: number, b: number) => {
            return a - b;
        });


        return ids;
    }



    /**
     * 通过古宝id获取古宝配置
     */
    public GetSoapConfBySoapId(soapId: number): ISConfSoap {
        let conf: ISConfSoap = this.confEnchantmentGuardSoap[soapId.toString()];
        if (!conf) {
            console.error(`config_enchantment_guard_soap----读取配置错误------该配置中没有--${soapId}`);
        }

        return conf;

    }

    /**
     * 通过古宝id以及碎片id获取碎片配置
     */
    public GetSoapConfBySoapIdAndDebrisId(soapId: number, debrisId: number) {
        let conf: ISConfSoapDebris = this.confEnchantmentGuardSoapDebris[`${soapId}@${debrisId}`];
        if (!conf) {
            console.error(`config_enchantment_guard_soap_debris----读取配置错误------该配置中没有--${soapId}@${debrisId}`);
        }

        return conf;
    }


    /**
     * 获取当前古宝总属性
     */
    public GetCurSoapAttrs() {
        let soaps: IS2CMosterParam[] = this.GetSoapsMapValues();
        let attrs: any[] = [];
        for (const iterator of soaps) {
            for (const debris of iterator.debris_list) {
                let conf: ISConfSoapDebris = this.GetSoapConfBySoapIdAndDebrisId(iterator.soap_id, debris.debris_id);
                let attr = ErlangParser.GetInstance().parse(conf.attr);
                attrs = attrs.concat(attr);
            }
        }

        let attrMap: TMap<number, any> = new TMap<number, any>();

        for (const iterator of attrs) {
            let attr = attrMap.get(iterator[0])
            if (attr) {
                attrMap.set(iterator[0], { 0: iterator[0], 1: Number(attr[1]) + Number(iterator[1]) });
            } else {
                attrMap.set(iterator[0], { 0: iterator[0], 1: Number(iterator[1]) });
            }
        }

        return attrMap.values;

    }

    /**
     * 获取该古宝的总属性
     */
    public GetAttrsBySoapId(soapId: number) {
        let ids: number[] = this.GetFragmentsAllBySoapId(soapId);
        let attrs: any[] = [];
        for (const iterator of ids) {
            let conf: ISConfSoapDebris = this.GetSoapConfBySoapIdAndDebrisId(soapId, iterator);
            let attr = ErlangParser.GetInstance().parse(conf.attr);
            attrs = attrs.concat(attr);
        }

        let attrMap: TMap<number, any> = new TMap<number, any>();

        for (const iterator of attrs) {
            let attr = attrMap.get(iterator[0])
            if (attr) {
                attrMap.set(iterator[0], { 0: iterator[0], 1: Number(attr[1]) + Number(iterator[1]) });
            } else {
                attrMap.set(iterator[0], { 0: iterator[0], 1: Number(iterator[1]) });
            }
        }

        return attrMap.values;


    }


    /**
     * 通过碎片物品id获取关卡数
     */
    GetGateByGoodsId(goodsId: number): number {
        for (const key in this.confEnchantmentGuardStageReward) {
            if (Object.prototype.hasOwnProperty.call(this.confEnchantmentGuardStageReward, key)) {
                const conf = this.confEnchantmentGuardStageReward[key];
                let cost = JSON.parse(conf.reward)[0];
                if (cost[1] == goodsId) {
                    return conf.gate;
                }
            }
        }

        return 0;
    }

    /**
     * 该古宝是否激活
     */
    GetActBySoapId(soapId: number) {
        let monster: IS2CMosterParam = this.GetSoapsBySoapIdMap(soapId);
        if (!monster) {
            return false;
        }

        let actIds: { debris_id: number }[] = monster?.debris_list || [];
        let ids: number[] = this.GetFragmentsAllBySoapId(soapId);

        let bool: boolean = ids.every((id: number) => {
            let index: number = actIds?.findIndex((item: { debris_id: number }) => {
                return item.debris_id == id;
            });
            return index > -1
        });

        return bool;

    }

    /**
     * 改碎片是否激活
     */
    GetActByDebrisId(soapId: number, debrisId: number): boolean {
        let monster: IS2CMosterParam = this.GetSoapsBySoapIdMap(soapId);
        if (!monster) {
            return false;
        }

        let actIds: { debris_id: number }[] = monster?.debris_list || [];
        let index: number = actIds?.findIndex((item: { debris_id: number }) => {
            return item.debris_id == debrisId;
        })

        return (index > -1);
    }


    /**
     * 
     * @returns 
     */

    UpdateSoapRedDot(){
        if(this.refresh_time_id)
            return

        this.refresh_time_id = setTimeout(() => {
            this.refresh_time_id = undefined
            let bool: boolean = false
            if (this.confEnchantmentGuardSoap) {
                let keys: string[] = Object.keys(this.confEnchantmentGuardSoap);
                bool = keys.some((key: string) => {
                    return this.GetSoapRedDot(+key);
                });
            }
            if(this.red_state != bool){
                this.red_state = bool
                RedDotController.ins.up(RedKey.MONSTER_SOAP, bool ? 1 : 0);
                this.Fire(MonsterModelEvent.UPDATE_RED_DOT);
            }
        }, 500);
    }
    /**
     * 古宝总红点
     */
    GetSoapRedDotAll() {
        return this.red_state;
    }


    /**
     * 获取古宝红点
     * @param soapId 
     */
    GetSoapRedDot(soapId: number) {
        let showIds: number[] = this.GetShowSoapIds();

        if (showIds.indexOf(soapId) == -1) {
            return false;
        }

        let ids: number[] = this.GetFragmentsAllBySoapId(soapId);
        let bool: boolean = ids.some((id: number) => {
            return this.GetDebrisRedDot(soapId, id);
        });

        return bool;
    }



    /**
     * 获取碎片红点
     * @param soapId 
     * @param debrisId 
     */
    GetDebrisRedDot(soapId: number, debrisId: number) {
        // 判断前一个古宝的碎片是否都已经激活
        let superiorSoap: number = soapId - 1;
        let confSoap: ISConfSoap = this.confEnchantmentGuardSoap[superiorSoap];
        if (confSoap) { // 如果读取不到证明是第一个古宝,第一个古宝则不需要判定前古宝是否都激活碎片
            let act: boolean = this.GetActBySoapId(superiorSoap);
            if (!act) { // 上一个古宝未激活该碎片不能有红点
                return false;
            }
        }


        let conf: ISConfSoapDebris = this.GetSoapConfBySoapIdAndDebrisId(soapId, debrisId);
        let cost = ErlangParser.GetInstance().parse(conf.cost)[0];
        let totalNum: number = GoodsModel.GetInstance().GetTypeGoodsNum(cost[1]);

        return totalNum >= cost[2];
    }


    /**
     * 左边箭头红点
     */
    GetLeftRedDot(index: number) {
        let ids: number[] = this.GetShowSoapIds();
        for (let i = index - 1; i >= 0; i--) {
            if (this.GetSoapRedDot(ids[i])) {
                return true;
            }
        }

        return false;
    }


    /**
     * 右边箭头红点
     */
    GetRightRedDot(index: number) {
        let ids: number[] = this.GetShowSoapIds();
        for (let i = index + 1; i < ids.length; i++) {
            if (this.GetSoapRedDot(ids[i])) {
                return true;
            }
        }

        return false;
    }














}

window['MonsterModel'] = MonsterModel;

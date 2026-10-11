import { table } from '../common/table';
import { EventDispatcher } from '../util/EventDispatcher';
import { TMap } from '../util/TMap';
import { EquipDefine, EquipModel } from './EquipModel';
import { Config } from "../common/Config"
import { RoleManager } from './RoleManager';
import { GoodsModel } from './GoodsModel';
import { EquipSuitBaseView } from '../suit/EquipSuitBaseView';
import { CommonManager } from '../common/CommonManager';

/**各位置套装状态 */
export interface IS2CSuitListParam {
    suit_list: IS2CSuitListInfoParam[],
}

export interface IS2CSuitListInfoParam {
    equip_type: number,   // 装备位置
    type: number,  // 共鸣类型 1 - 3
    slv: number,  // 第几阶
}

export interface IS2CSuitListPowerParam {
    list: IS2CSuitListPowerInfoParam[],
}

export interface IS2CSuitListPowerInfoParam {
    num: number,      // 套装件数
    combat: number    // 战力加成  
}

export enum EnumSuitType {
    eEquip = 1,
    eFairyDevice
}

export enum EnumSubType {
    eOne = 1,
    eTwo,
    eThree
}

export enum EnumSuitTabType {
    /**妖魂 */
    eDemonSoul,
    /**修罗 */
    eShura,
    /**万物 */
    eAllThings,
    /**饰物 */
    eDecorations
}


/**
 * 共鳴事件类型类
 */
export class SuitModelEvent {
    static _cname = 'SuitModelEvent';
    /**装备选中 */
    public static TAB_SELECT: string =
        SuitModelEvent._cname + '.' + 'TAB_SELECT';
    /**共鸣打造 */
    public static UP_SUIT_SUCCESS: string =
        SuitModelEvent._cname + '.' + 'UP_SUIT_SUCCESS';
    /**共鸣套装战力更新 */
    public static UP_SUIT_POWER: string =
        SuitModelEvent._cname + '.' + 'UP_SUIT_POWER';
    /**更新共鸣部位信息 */
    public static UP_SUIT_POS_INFO: string =
        SuitModelEvent._cname + '.' + 'UP_SUIT_POS_INFO';
    /**更新共鸣部位回退 */
    public static BACK_SUIT_SUCCESS: string =
        SuitModelEvent._cname + '.' + 'BACK_SUIT_SUCCESS';
    /**更新总红点 */
    public static UP_SUIT_RED: string =
        SuitModelEvent._cname + '.' + 'UP_SUIT_RED';
}

export class SuitModel extends EventDispatcher {
    private static _instance: SuitModel;
    public static GetInstance() {
        if (!SuitModel._instance) {
            SuitModel._instance = new SuitModel();
        }
        return SuitModel._instance;
    }

    // 套装状态
    private _suits: TMap<string, IS2CSuitListInfoParam>;
    private _suitPower: TMap<string, IS2CSuitListPowerInfoParam[]>;
    // 所有套装类型以及子类型
    private readonly _suitTypeAndSubTypeList = [[1, 1], [1, 2], [1, 3], [2, 1]]; // 写死策划没有配置

    // 配置
    private confEquipPos2SuitType: any = null;
    private confSuitItem: any = null;
    private confSuitMake: any = null;
    private confOpen: any = null;

    public constructor() {
        super();
        this._suits = new TMap<string, IS2CSuitListInfoParam>();
        this._suitPower = new TMap<string, IS2CSuitListPowerInfoParam[]>();
    }


    InitConf() {
        this.confEquipPos2SuitType = Config.PRELOAD_SERVER_CONFIG.config_equip_pos2suittype;
        this.confSuitItem = Config.PRELOAD_SERVER_CONFIG.config_equip_suit_item;
        this.confSuitMake = Config.PRELOAD_SERVER_CONFIG.config_equip_suit_make;
        this.confOpen = Config.PRELOAD_CLIENT_CONFIG.ConfigFuncOpenCondition;
    }


    GetSuitTypeAndSubTypeList() {
        return this._suitTypeAndSubTypeList;
    }


    /**
     * 获取套装部位信息
     */
    GetSuitPos(suitType: number, subType: number, pos: number): IS2CSuitListInfoParam {
        return this._suits.get(suitType + '' + subType + pos);
    }

    /**
     * 获取所有套装部位信息
     */
    GetSuitPosAll(): IS2CSuitListInfoParam[] {
        return this._suits.values;
    }


    /**
     * 设置套装属性信息
     */
    SetSuitPos(suit: IS2CSuitListInfoParam) {
        let conf = this.confEquipPos2SuitType[suit.equip_type];
        this._suits.set(conf.type + '' + suit.type + suit.equip_type, suit);
    }

    /**
     * 清理共鸣部位信息
     */
    ClearSuitPos() {
        this._suits.clear();
    }

    /**
     * 获取套装战力
     * @param pos 部位
     * @param subType 子类型
     * @param lv 共鸣等级
     * @returns 
     */
    GetSuitsPower(pos: number, subType: number, lv: number): IS2CSuitListPowerInfoParam[] {
        return this._suitPower.get(pos + '' + subType + lv);
    }

    /**
     * 获取套装战力
     * @param pos 部位
     * @param subType 子类型
     * @param lv 共鸣等级
     * @param list 该套装功战力
     * @returns 
     */
    SetSuitsPower(pos: number, subType: number, lv: number, list: IS2CSuitListPowerInfoParam[]) {
        this._suitPower.set(pos + '' + subType + lv, list);
    }

    /**
     * 所有套装战力
     */
    GetSuitsPowerAll() {
        return this._suitPower.values;
    }

    /**
     * 清理共鸣套装战力信息
     */
    ClearSuitPower() {
        this._suitPower.clear();
    }



    /**
     * 判断
     */
    public GetIsEquip(pos: number) {
        return EquipModel.GetInstance().GetSuitType(pos) == EnumSuitType.eEquip;
    }

    /**
     * 判断
     */
    public GetIsFairyDevice(pos: number) {
        return EquipModel.GetInstance().GetSuitType(pos) == EnumSuitType.eFairyDevice;
    }

    /**
     * 获取该类型的该部位相同共鸣等级的总数量
     * @param suitype EnumSuitType
     * @param subType EnumSubType
     * @param pos 装备部位
     * @param suitlv 套装等级
     * @returns 
     */
    public GetTypePosLevelNum(suitype: number, subType: number, pos: number, suitlv: number) {
        let suits: IS2CSuitListInfoParam[] = this.GetSuitPosAll();
        if (suits?.length) {
            let sum: number = suits.reduce((pre: number, data: IS2CSuitListInfoParam, index: number) => {
                let curSuitType: number = EquipModel.GetInstance().GetSuitType(data.equip_type);
                return pre += Number(curSuitType == suitype && data.type == subType && (suitype == EnumSuitType.eEquip ? data.slv == suitlv : data.slv >= suitlv));
            }, 0);

            return sum;
        }

        return 0;

    }


    /**
     * 获取装备列表
     * @param suitType EnumSuitType
     * @param subType 共鸣类型
     * @returns 
     */
    public GetEquipInfos = (suitType: number, subType: number) => {
        let list = []
        for (let i = 0; i < EquipDefine.EQUIP_POS.length; i++) {
            let pos = EquipDefine.EQUIP_POS[i];
            let type: number = EquipModel.GetInstance().GetSuitType(pos);
            let dynamic = EquipModel.GetInstance().GetWearEquipDynamic(pos);
            if (suitType == type) {
                table.insert(list, {
                    is_empty: !dynamic,
                    equip_type: pos,
                    subType: subType,
                    dynamic: dynamic,
                    isEquipType: this.GetIsEquip(pos),
                    stage: EquipModel.GetInstance().GetStageByTypeId(dynamic && dynamic.type_id)
                })
            }
        }
        return list
    }

    /**
     * 共鸣总红点
     */
    public GetSuitTotlaRed() {
        let isOpen: boolean = CommonManager.GetInstance().CheckFuncOpenState(EquipSuitBaseView._layout_file, true);
        if (!isOpen) {
            return false;
        }

        let types: number[][] = this._suitTypeAndSubTypeList;
        let bool: boolean = types.some((typeList: number[]) => {
            let [suitType, subType] = [...typeList];
            return this.GetSuitTypeSubTypePosRedAll(suitType, subType);
        });
        return bool;
    }


    /**
     * 获取页签总红点
     * @param suitType EnumSuitType
     * @param subType 子类型
     */
    public GetSuitTypeSubTypePosRedAll(suitType: number, subType: number) {
        let posAll: number[] = EquipDefine.EQUIP_POS.filter((pos: number) => {
            return suitType == EnumSuitType.eEquip ? this.GetIsEquip(pos) : this.GetIsFairyDevice(pos);
        });

        let bool: boolean = posAll.some((pos: number) => {
            return this.GetSuitTypeSubTypePosShowRed(suitType, subType, pos);
        });

        return bool;
    }


    /**
     * 获取大类型中子类的中的部位红点
     */
    public GetSuitTypeSubTypePosRed(suitType: number, subType: number, pos: number) {
        let suit: IS2CSuitListInfoParam = this.GetSuitPos(suitType, subType, pos);

        // 未穿戴无红点
        let equip = EquipModel.GetInstance().GetWearEquipDynamic(pos);
        let dynamic: boolean = Boolean(equip);
        if (!dynamic) {
            return false;
        }
        let confs = SuitModel.GetInstance().GetConfSuitMakeListBySuitTypeAndSubType(pos, subType);
        let confMake: any = confs[confs.length - 1];
        // 判断是否满级
        if (suit?.slv && suit?.slv >= confMake.slv) {
            return false;
        }

        // 判断是否满足升阶条件
        let makeCfg = this.GetConfSuitMakeInfo(pos, subType, (suit?.slv || 0) + 1);
        if (!makeCfg) {
            return false;
        }
        let conditionList = JSON.parse(makeCfg.condition);
        // 先判断是否满足条件
        let needQua: number = conditionList[0][1]; // 需要达到品质
        let needStar: number = conditionList[0][2]; // 需要达到星级
        let needOrder: number = conditionList[1][2]; // 需要达到阶数

        let meStar: number = EquipModel.GetInstance().GetStarByTypeId(equip.type_id);
        let meOrder: number = EquipModel.GetInstance().GetStageByTypeId(equip.type_id);

        // 判断品质/星级/阶数
        if (needQua > equip.color || needStar > meStar || needOrder > meOrder) {
            return false;
        }

        return this.GetSuitMakeCostState(pos, subType, (suit?.slv || 0) + 1);

        // let costs: any[] = this.GetSuitMakeCost(pos, subType, (suit?.slv || 0) + 1);
        // if (costs.length > 0 && dynamic) {
        //     let goods_model: GoodsModel = GoodsModel.GetInstance()
        //     let bool: boolean = costs.every((info, index) => {
        //         let [type_id, is_lock] = goods_model.GetMappingTypeId(info[0], info[1]);
        //         let own: number = goods_model.GetTypeGoodsNum(type_id);
        //         return own >= Number(info[2]);
        //     });
        //     return bool;
        // }
        // return false;
    }

    /**
     * 判断该部位是否满足打造条件
     */
    public GetSuitMakeConditionsState(suitType: number, subType: number, pos: number) {
        let equip = EquipModel.GetInstance().GetWearEquipDynamic(pos);
        let dynamic: boolean = Boolean(equip);
        if (!dynamic) {
            return false;
        }

        let suit: IS2CSuitListInfoParam = this.GetSuitPos(suitType, subType, pos);
        let confs = SuitModel.GetInstance().GetConfSuitMakeListBySuitTypeAndSubType(pos, subType);
        let confMake: any = confs[confs.length - 1];
        // 判断是否满级
        if (suit?.slv && suit?.slv >= confMake.slv) {
            return true;
        }

        // 判断是否满足升阶条件
        let makeCfg = this.GetConfSuitMakeInfo(pos, subType, (suit?.slv || 1));
        if (!makeCfg) {
            return false;
        }
        let conditionList = JSON.parse(makeCfg.condition);
        // 先判断是否满足条件
        let needQua: number = conditionList[0][1]; // 需要达到品质
        let needStar: number = conditionList[0][2]; // 需要达到星级
        let needOrder: number = conditionList[1][2]; // 需要达到阶数

        let meStar: number = EquipModel.GetInstance().GetStarByTypeId(equip.type_id);
        let meOrder: number = EquipModel.GetInstance().GetStageByTypeId(equip.type_id);

        // 判断品质/星级/阶数
        if (equip.color >= needQua && meStar >= needStar && meOrder >= needOrder) {
            return true;
        }

        return false;
    }


    /**
     * 是否满足材料
     * @param pos 
     * @param subType 
     * @param lv 
     * @returns 
     */
    public GetSuitMakeCostState(pos: number, subType: number, lv: number) {
        let equip = EquipModel.GetInstance().GetWearEquipDynamic(pos);
        let dynamic: boolean = Boolean(equip);
        let costs: any[] = this.GetSuitMakeCost(pos, subType, lv);
        if (costs.length > 0 && dynamic) {
            let goods_model: GoodsModel = GoodsModel.GetInstance()
            let bool: boolean = costs.every((info, index) => {
                let [type_id, is_lock] = goods_model.GetMappingTypeId(info[0], info[1]);
                let own: number = goods_model.GetTypeGoodsNum(type_id);
                return own >= Number(info[2]);
            });
            return bool;
        }
        return false;
    }


    /**
     * 红点是否显示
     * @param suitType 
     * @param subType 
     * @param pos 
     */
    public GetSuitTypeSubTypePosShowRed(suitType: number, subType: number, pos: number) {
        let red: boolean = this.GetSuitTypeSubTypePosRed(suitType, subType, pos);
        if (!red) {
            return false;
        }

        let suit: IS2CSuitListInfoParam = this.GetSuitPos(suitType, subType, pos);

        // 当前部位的共鸣等级是否在生效共鸣属性
        let conf = this.GetConfSuitItemInfo(suitType, subType, (suit?.slv || 1));
        let curNum: number = this.GetTypePosLevelNum(suitType, subType, pos, (suit?.slv || 0));
        let attrs = JSON.parse(conf.attr_list);
        let minCount: number = attrs[0][0];
        if (!(curNum >= minCount)) {
            return true;
        }

        let suitLv: number = (suit?.slv || 0)
        //下一级的共鸣等级
        let nextSuitLv: number = suitLv + 1;

        // 下一级的共鸣等级部位数是否为双数
        let nextNum: number = this.GetTypePosLevelNum(suitType, subType, pos, nextSuitLv) + 1; // +1是算上自身

        // 能同时打造的同阶的部位是否为双数
        let equips = this.GetEquipInfos(suitType, subType).filter((data) => {
            let local_suit: IS2CSuitListInfoParam = this.GetSuitPos(suitType, subType, data.equip_type);
            let lv_cond = !suitLv || !local_suit || suitLv == local_suit.slv
            return lv_cond && this.GetSuitTypeSubTypePosRed(suitType, subType, data.equip_type);
        });

        let isNeed: boolean = false;
        if (equips.length % 2 == 0) {
            let costs: any[] = this.GetSuitMakeCost(pos, subType, nextSuitLv);
            if (costs.length > 0) {
                let goods_model: GoodsModel = GoodsModel.GetInstance()
                isNeed = costs.every((info, index) => {
                    let [type_id, is_lock] = goods_model.GetMappingTypeId(info[0], info[1]);
                    let own: number = goods_model.GetTypeGoodsNum(type_id);
                    return own >= Number(info[2] * 2); // *2是因为要满足两件同等级的材料打造
                });
            }
        }
        return (isNeed || (nextNum % 2 == 0));
    }



    /**
     * 获取条件消耗
     * @param pos 位置
     * @param subType EnumSubType 
     * @param lv 共鸣等级
     * @returns 
     */
    public GetSuitMakeCost(pos: number, subType: number, lv: number) {
        let cfg = this.GetConfSuitMakeInfo(pos, subType, lv)
        if (!cfg) {
            return [];
        }
        let sex: number = RoleManager.GetInstance().GetMainRoleVo().sex;
        let cost_cfg = JSON.parse(cfg.cost)
        for (let key in cost_cfg) {
            let info = cost_cfg[key]
            if (Number(info[0]) == sex) {
                return info[1];
            }
        }
        return [];
    }

    /**
     * 获取所有相同共鸣类型以及子类型的配置项
     * @param suitType EnumSuitType
     * @param subType 共鸣子类型
     */
    public GetConfSuitItemListBySuitTypeAndSubType(suitType: number, subType: number) {
        if (!this.confSuitItem) {
            return [];
        }
        let confs: any[] = [];
        for (const key of Object.keys(this.confSuitItem)) {
            let conf = this.confSuitItem[key];
            if (conf.type == suitType && conf.lv == subType) {
                confs.push(conf);
            }
        }

        confs.sort((a, b) => {
            return a.slv - b.slv;
        });

        return confs;
    }

    /**
     * 获取所有相同共鸣类型以及子类型的配置项
     * @param subType EnumSubType
     * @param pos 装备部位
     */
    public GetConfSuitMakeListBySuitTypeAndSubType(pos: number, subType: number) {
        if (!this.confSuitMake) {
            return [];
        }
        let confs: any[] = [];
        for (const key of Object.keys(this.confSuitMake)) {
            let conf = this.confSuitMake[key];
            if (conf.lv == subType && conf.pos == pos) {
                confs.push(conf);
            }
        }

        confs.sort((a, b) => {
            return a.slv - b.slv;
        });

        return confs;
    }

    /**
     * 获取共鸣类型配置项
     * @param suitType EnumSuitType
     * @param subType 共鸣子类型
     * @param lv 共鸣等级
     * @returns 
     */
    public GetConfSuitItemInfo(suitType: number, subType: number, lv: number) {
        return this.confSuitItem[`${suitType}@${subType}@${lv}`];
    }

    /**
     * 获取条件配置项
     * @param pos 位置
     * @param subType EnumSubType 
     * @param lv 共鸣等级
     * @returns 
     */
    public GetConfSuitMakeInfo(pos: number, subType: number, lv: number) {
        return this.confSuitMake[`${pos}@${subType}@${lv}`];
    }

    /**
     * 获取位置配置项
     * @param pos 位置
     * @param subType EnumSubType 
     * @param lv 共鸣等级
     * @returns 
     */
    public GetConfPos2SuitTypeInfo(pos: number, subType: number, lv: number) {
        return this.confSuitMake[`${pos}@${subType}@${lv}`];
    }

    /**
     * 获取该部位装备最大能达到的共鸣等级配置
     * @param pos 部位
     * @param suitType EnunSuitType
     * @param subType EnumSubType
     * @returns 
     */
    public GetConfEquipMaxSuitLv(pos: number, suitType: number, subType: number) {
        let confs: any[] = this.GetConfSuitMakeListBySuitTypeAndSubType(pos, subType);
        let suit: IS2CSuitListInfoParam = this.GetSuitPos(suitType, subType, pos);
        let suitLv: number = suit?.slv || 0;
        confs = confs.filter((conf: any) => {
            let conditionList = JSON.parse(conf.condition);
            // 先判断是否满足条件
            let needQua: number = conditionList[0][1]; // 需要达到品质
            let needStar: number = conditionList[0][2]; // 需要达到星级
            let needOrder: number = conditionList[1][2]; // 需要达到阶数

            let dynamic = EquipModel.GetInstance().GetWearEquipDynamic(pos);
            let meStar: number = EquipModel.GetInstance().GetStarByTypeId(dynamic.type_id);
            let meOrder: number = EquipModel.GetInstance().GetStageByTypeId(dynamic.type_id);

            return dynamic.color >= needQua && meStar >= needStar && meOrder == needOrder;//&& conf.slv > suitLv;
        });

        if (confs.length > 0) {
            let conf = confs[confs.length - 1];
            return conf;
        }

        return null;
    }

    /**
     * 获取该类型套装激活的属性件数
     */
    public GetSuitTypeMaxAttrs(pos: number, suitType: number, subType: number, suitList: { suit_lv: number, suit_slv: number, suit_count: number }[]) {
        let confs = this.GetConfSuitItemListBySuitTypeAndSubType(suitType, subType);
        // 该部位已激活的件数
        let numMap: TMap<number, any> = new TMap<number, any>();
        for (const conf of confs) {
            suitList.sort((a, b) => {
                return b.suit_count - a.suit_count;
            });
            let find = suitList.find((data) => {
                return data.suit_lv == subType && conf.slv == data.suit_slv;
            });
            if (find) {
                let count: number = find?.suit_count || 0;   // this.GetTypePosLevelNum(suitType, subType, pos, conf.slv)
                let attrList: any[] = JSON.parse(conf.attr_list);
                for (const attr of attrList) {
                    let num: number = attr[0];
                    if (count >= num) {
                        numMap.set(num, { conf: conf, attrs: attr[1], count: num, curCount: count });
                    }
                }
            }
        }

        return numMap.values;


    }

    /**
     * 该部位装备显示的特效没有则为空
     * @param pos 部位
     * @param goodsId 商品id
     */
    public GetPosEquipShowSuitAni(pos: number, goodsId: number) {
        if (EquipModel.GetInstance().GetIsWearByGoodsId(goodsId)) {
            for (let i = (this.GetIsEquip(pos) ? EnumSubType.eThree : EnumSubType.eOne); i >= EnumSubType.eOne; i--) {
                const subType: EnumSubType = i;
                let suitType: number = EquipModel.GetInstance().GetSuitType(pos);
                let conf = this.GetConfEquipMaxSuitLv(pos, suitType, subType);
                let suit: IS2CSuitListInfoParam = this.GetSuitPos(suitType, subType, pos);
                if ((suit?.slv || 0) >= (conf?.slv || 1)) {
                    return this.GetEffNameByType(suitType, subType);
                }
            }
        }

        return null;
    }


    /**
     * 获取默认有红点的页签索引
     */
    public GetDefTabIndexRed() {
        for (let i = EnumSuitTabType.eDemonSoul; i <= EnumSuitTabType.eDecorations; i++) {
            let [suitType, subType] = [...this._suitTypeAndSubTypeList[i]];
            let red: boolean = this.GetSuitTypeSubTypePosRedAll(suitType, subType);
            if (red) {
                return i;
            }
        }

        return 0;
    }



    /**
     * 获取页签对应品质色
     * @param suitType 
     * @param subType 
     */
    public GetColorByType(suitType: number, subType: number) {
        if (suitType == EnumSuitType.eEquip) {
            switch (subType) {
                case EnumSubType.eOne:
                    return "'#1d85dd'";
                case EnumSubType.eTwo:
                    return "'#c41ddd'";
                case EnumSubType.eThree:
                    return "'#ff604c'";
            }
        } else {
            return "'#f5b328'";
        }
    }

    /**
     * 获取页签特效品质
     * @param suitType 
     * @param subType 
     */
    public GetEffNameByType(suitType: number, subType: number) {
        if (suitType == EnumSuitType.eEquip) {
            switch (subType) {
                case EnumSubType.eOne:
                    return 'ui_shenzhuang01';
                case EnumSubType.eTwo:
                    return 'ui_shenzhuang02';
                case EnumSubType.eThree:
                    return 'ui_shenzhuang03';
            }
        } else {
            return 'ui_shenzhuang03';
        }
    }

    /**
     * 获取特效品质对应子页签
     * @param aniStr 
     * @returns 
     */
    public GetSubTypeByEffName(aniStr: string) {
        switch (aniStr) {
            case 'ui_shenzhuang01':
                return EnumSubType.eOne;
            case 'ui_shenzhuang02':
                return EnumSubType.eTwo;
            case 'ui_shenzhuang03':
                return EnumSubType.eThree;
        }
    }

    /**
     * 通过typeId获取穿戴的装备的商品唯一id没有则返回0
     * @param typeId 
     * @returns 
     */
    public GetWearGoogdsIdByTypeId(typeId: number) {
        for (let i = 0; i < EquipDefine.EQUIP_POS.length; i++) {
            let pos = EquipDefine.EQUIP_POS[i];
            let dynamic = EquipModel.GetInstance().GetWearEquipDynamic(pos);
            if (dynamic && dynamic.type_id == typeId) {
                return dynamic.goods_id;
            }
        }
        return 0;
    }


}

window['SuitModel'] = SuitModel;

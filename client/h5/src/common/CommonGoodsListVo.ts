import { UserMsgAdapter } from "./UserMsgAdapter";
/**
 * //数值类型映射到真实物品类型id
    表示展示列表(可用于展示消耗或者奖励列表)，默认结构为:
    0： 物品
    1:	钻石
    2:	绑定钻石
    3:	卢币
    4:	结社币
    5:	经验
    6:  花香值
    7:  鲜花值
    8:	结社资金
    9：	结社贡献度
    100：	绑定物品
    101：	是否绑定 + 是否限时物品
 
    结构1：
    array(
            int:8 展示类型(参照上表)
            int:32 具体类型id(如物品id)
            int:32 数量
        )
 *
 */
export enum GoodsType {
    Goods = 0,
    Zuanshi = 1,
    Bangzuan = 2,
    Lubi = 3,
    Gonghuibi = 4,
    Exp = 5,
    Huaxiangzhi = 6,
    Xianhuazhi = 7,
    Gonghuizijin = 8,
    Gonghuigongxiandu = 9,
    BandGoods = 100,
    BangLimitTimeGoods = 101
}
window["GoodsType"] = GoodsType;
export class CommonGoodsListVo {
    public static pro_list = [
        ["style", "c"],
        ["typeId", "i"],
        ["count", "i"],
    ];
    public constructor() {
    }
    public ReadFmt(target?) {
        let self = this, user_msg_adapter = UserMsgAdapter.GetInstance(), len: number = user_msg_adapter.ReadFmt("h"), goods_list = [];
        if (target) {
            target.goods_list = goods_list;
        }
        let vo;
        let list_vo;
        for (let i = 0; i < len; i++) {
            list_vo = {};
            for (let j = 0; j < CommonGoodsListVo.pro_list.length; j++) {
                vo = CommonGoodsListVo.pro_list[j];
                list_vo[vo[0]] = user_msg_adapter.ReadFmt(vo[1]);
            }
            goods_list.push(list_vo);
        }
        return goods_list;
    }
}

window["CommonGoodsListVo"] = CommonGoodsListVo
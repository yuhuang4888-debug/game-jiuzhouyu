type ProtoSendFunc<T extends keyof ProtoFmtInfo> = ProtoFmtInfo[T]['send'];
type ProtoSendFmts<T extends keyof ProtoFmtInfo> = ProtoFmtInfo[T]['sendFmt'];
type ProtoSendArgs<T extends keyof ProtoFmtInfo> = ProtoFmtInfo[T]['sendArgs'];
type ProtoRecvVObj<T extends keyof ProtoFmtInfo> = ProtoFmtInfo[T]['recv'];
type Proto = keyof ProtoFmtInfo;
// 判断是否是any类型
type CheckNever<T> = T extends never ? 'yes' : 'no';
type CheckAny<T> = CheckNever<T> extends 'no' ? false : true;

// 获取数组类型
type ArrayElement<A> = A extends readonly (infer T)[] ? T : never;
// 动态添加的装备属性
declare interface IEquipBaseInfo {
    star: number;
    stage: number;
    base_rating: number;
    bad_type: number;
}
// 动态添加的物品类型
declare interface IGoodsBaseInfo {
    goods_name: string;
    type: number;
    subtype: number;
    level: number;
    goods_icon: number;
    career_id: number;
    equip_type: number;
    use: number;
    sell: number;
    compose;
    identify;
    intro;
    price_type;
    sell_price;
    sex;
    turn;
    color;
    base_attrlist;
}
declare interface ProtoFmtInfo {
    [key: number | string]: {
        sendFmt: string;
        sendArgs: any;
        send: any;
        recv: any;
    };
}
declare type IGoods = Partial<ArrayElement<ProtoRecvVObj<15010>['goods_list']> & IGoodsBaseInfo>;
declare type IGuildDepoGoods = Partial<ArrayElement<ProtoRecvVObj<40101>['depot_goods']> & IGoodsBaseInfo & IEquipBaseInfo & { is_item: boolean }>;
declare type IGuildDepoInfo = Partial<ProtoRecvVObj<40101> & { depot_goods: IGuildDepoGoods[] }>;

declare type IDungeonResultInfo = Partial<ProtoRecvVObj<61003> & { dun_type: number; result_type: number }>;

declare type IShopGoodsInfo = Partial<ArrayElement<ProtoRecvVObj<15301>['goods_list']> & {series_list: string[]}>
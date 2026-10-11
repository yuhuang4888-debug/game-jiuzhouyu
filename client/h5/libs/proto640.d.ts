/** 抢购商城
 */
declare interface ProtoFmtInfo {
    64000: {
        desc: "限购商品列表";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            id_list: {
                /** 抢购商城物品id */
                id: number;
                /** 物品类型id */
                good_id: number;
                /** 限购数量 */
                default_num: number;
                /** 钻石类型：1为钻石，2为绑钻 */
                price_type: number;
                /** 原价钻石数量 */
                old_price: number;
                /** 现价钻石数量 */
                new_price: number;
                /** 全服限购数量 */
                total_limit_num: number;
                /** 全服剩下限购数量 */
                left_limit_num: number;
                /** 每日限购次数 */
                daily_limit_num: number;
                /** 玩家当天购买,1为已买，0为未买 */
                buy_num: number;
            }[];
        };
    };
    64001: {
        desc: "购买";
        send: (
            number: 64001,
            fmt: "ii",
            args: [
                /**抢购商城物品id*/
                id: number,
                /**购买次数*/
                num: number
            ]
        ) => never;
        sendFmt: "ii";
        sendArgs: [
            /**抢购商城物品id*/
            id: number,
            /**购买次数*/
            num: number
        ];
        recv: {
            /** 错误码：1为成功 */
            errcode: number;
            /** 抢购商城物品id */
            id: number;
            /** 本角色已购买的数量 */
            buy_num: number;
            /** 全服剩下该物品限购数量 */
            left_limit_num: number;
        };
    };
    64002: {
        desc: "商品数量变化";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            change_list: {
                /** 抢购商城物品id */
                id: number;
                /** 全服剩下限购数量 */
                left_limit_num: number;
            }[];
        };
    };
    64003: {
        desc: "下架商品";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            del_list: {
                /** 抢购商城物品id */
                id: number;
            }[];
        };
    };
}

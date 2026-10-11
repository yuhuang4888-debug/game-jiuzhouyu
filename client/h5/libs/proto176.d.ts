/** 神秘限购
 */
declare interface ProtoFmtInfo {
    17600: {
        desc: "打开神秘限购";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            errcode: number;
            sell_list: {
                /** 商品id */
                sell_id: number;
                /** 开始时间戳 */
                start_time: number;
                /** 剩余数量 */
                less_num: number;
            }[];
        };
    };
    17601: {
        desc: "购买神秘限购";
        send: (
            number: 17601,
            fmt: "ih",
            args: [
                /**商品id*/
                sell_id: number,
                /**购买数量*/
                buy_num: number
            ]
        ) => never;
        sendFmt: "ih";
        sendArgs: [
            /**商品id*/
            sell_id: number,
            /**购买数量*/
            buy_num: number
        ];
        recv: {
            /** 错误码 */
            errcode: number;
            /** 商品id */
            sell_id: number;
            /** 购买数量 */
            buy_num: number;
        };
    };
    17602: {
        desc: "升级后新增物品";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            new_list: {
                /** 商品id */
                sell_id: number;
            }[];
        };
    };
}

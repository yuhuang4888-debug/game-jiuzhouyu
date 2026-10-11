/** 属性药剂
 */
declare interface ProtoFmtInfo {
    21700: {
        desc: "错误码";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            errcode: number;
        };
    };
    21701: {
        desc: "属性药剂次数";
        send: (
            number: 21701,
            fmt: "c",
            args: [
                /**初中高特级 1,2,3,4*/
                lv: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**初中高特级 1,2,3,4*/
            lv: number
        ];
        recv: {
            count_list: {
                /** 药剂类型id */
                goods_id: number;
                /** 初中高特级 1,2,3,4 */
                lv: number;
                /** 当日使用次数 */
                current_day_count: number;
                /** 玩家一共使用次数 */
                current_count: number;
            }[];
        };
    };
    21702: {
        desc: "吃药";
        send: (
            number: 21702,
            fmt: "iic",
            args: [
                goods_id: number,
                num: number,
                /**药剂等级*/
                lv: number
            ]
        ) => never;
        sendFmt: "iic";
        sendArgs: [
            goods_id: number,
            num: number,
            /**药剂等级*/
            lv: number
        ];
        recv: null;
    };
    21703: {
        desc: "属性药剂次数(全等级)";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            count_list: {
                /** 药剂类型id */
                goods_id: number;
                /** 初中高特级 1,2,3,4 */
                lv: number;
                /** 当日使用次数 */
                current_day_count: number;
                /** 玩家一共使用次数 */
                current_count: number;
            }[];
        };
    };
}

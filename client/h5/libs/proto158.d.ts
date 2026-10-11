/** 充值信息
 */
declare interface ProtoFmtInfo {
    15800: {
        desc: "充值界面信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            product_list: {
                /** 商品id */
                product_id: number;
                /** 返利类型  （0无返利|1终生首次|2活动时间首次） */
                return_type: number;
            }[];
        };
    };
    15801: {
        desc: "充值返利信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 商品id */
            product_id: number;
            /** 返利类型  （0无返利|1终生首次|2活动时间首次） */
            return_type: number;
        };
    };
    15802: {
        desc: "充值成功";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: null;
    };
    15803: {
        desc: "充值总额";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 钻石数 */
            gold: number;
        };
    };
    15804: {
        desc: "直购币充值礼包|内玩使用";
        send: (
            number: 15804,
            fmt: "i",
            args: [
                /**礼包商品ID*/
                product_id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**礼包商品ID*/
            product_id: number
        ];
        recv: {
            /** 错误码返回 */
            errcode: number;
        };
    };
    15899: {
        desc: "充值秘籍(封测阶段)";
        send: (
            number: 15899,
            fmt: "i",
            args: [
                /**商品id*/
                product_id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**商品id*/
            product_id: number
        ];
        recv: {
            /** 返回码 */
            res: number;
        };
    };
}

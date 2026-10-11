/** 藏宝图
 */
declare interface ProtoFmtInfo {
    20300: {
        desc: "错误码";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            code: number;
        };
    };
    20301: {
        desc: "坐标信息";
        send: (
            number: 20301,
            fmt: "l",
            args: [
                /**物品唯一id*/
                goods_id: number
            ]
        ) => never;
        sendFmt: "l";
        sendArgs: [
            /**物品唯一id*/
            goods_id: number
        ];
        recv: {
            code: number;
            /** 场景 */
            scene: number;
            /** 场景坐标x */
            x: number;
            /** 场景坐标y */
            y: number;
        };
    };
    20302: {
        desc: "抽奖";
        send: (
            number: 20302,
            fmt: "cl",
            args: [
                /**地图类型 地图类型    1 神秘图  2 传统图*/
                type: number,
                /**物品唯一id*/
                goods_id: number
            ]
        ) => never;
        sendFmt: "cl";
        sendArgs: [
            /**地图类型 地图类型    1 神秘图  2 传统图*/
            type: number,
            /**物品唯一id*/
            goods_id: number
        ];
        recv: {
            code: number;
            /** 地图类型    1 神秘图  2 传统图 */
            type: number;
            /** 1 稀有  0 不稀有 */
            is_rare: number;
            /** 奖励列表 */
            reward: any;
            /** 填充列表 */
            goods_list: any;
        };
    };
    20303: {
        desc: "跨服记录";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            log_list: {
                server_num: number;
                role_id: number;
                name: string;
                reward_list: any;
            }[];
        };
    };
    20304: {
        desc: "触发传闻";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: null;
    };
}

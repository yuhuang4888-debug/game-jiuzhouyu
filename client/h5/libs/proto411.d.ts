/** 称号
 */
declare interface ProtoFmtInfo {
    41101: {
        desc: "获取称号列表";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 当前使用的称号id */
            currentused: number;
            dsgt_list: {
                /** 称号Id */
                id: number;
                order: number;
                /** 大于 0 ： 结束时间戳   等于0 ：永久 */
                end_time: number;
            }[];
        };
    };
    41102: {
        desc: "佩戴称号";
        send: (
            number: 41102,
            fmt: "i",
            args: [
                /**称号id*/
                id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**称号id*/
            id: number
        ];
        recv: {
            /** 返回码 1成功 */
            code: number;
            /** 当前使用称号id */
            id: number;
        };
    };
    41103: {
        desc: "卸下称号";
        send: (
            number: 41103,
            fmt: "i",
            args: [
                /**称号id*/
                id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**称号id*/
            id: number
        ];
        recv: {
            /** 返回码 1成功 */
            code: number;
        };
    };
    41104: {
        desc: "获得称号通知";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 返回码 1成功 */
            code: number;
            /** id */
            id: number;
            /** 称号结束时间 */
            end_time: number;
        };
    };
    41105: {
        desc: "给场景玩家发送称号的变化";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 玩家id */
            player_id: number;
            /** 称号id */
            id: number;
        };
    };
    41106: {
        desc: "称号升阶、消耗物品激活";
        send: (number: 41106, fmt: "i", args: [id: number]) => never;
        sendFmt: "i";
        sendArgs: [id: number];
        recv: {
            /** 错误码 1表示成功 */
            errcode: number;
            /** 阶数 */
            order: number;
            /** 玩家升阶后增加的战力 */
            power: number;
            /** 玩家使用的称号id 	没有佩戴则为0 */
            currentused: number;
            /** 称号id，测试使用 */
            dsgtid: number;
        };
    };
    41107: {
        desc: "称号的假战力（评分）";
        send: (number: 41107, fmt: "i", args: [id: number]) => never;
        sendFmt: "i";
        sendArgs: [id: number];
        recv: {
            /** 错误码 1表示成功 */
            errcode: number;
            /** 称号的假战力（评分） */
            power: number;
        };
    };
    41108: {
        desc: "称号取消";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 只发送取消称号的id */
            dsgtid: number;
        };
    };
    41109: {
        send: (number: 41109, fmt: "i", args: [dsgtid: number]) => never;
        sendFmt: "i";
        sendArgs: [dsgtid: number];
        recv: {
            /** 错误码 1表示成功 */
            errcode: number;
            /** 玩家升阶后增加的战力 */
            power: number;
            /** 玩家使用的称号id 	没有佩戴则为0 */
            currentused: number;
            /** 称号id，测试使用 */
            dsgtid: number;
        };
    };
    41110: {
        desc: "处理称号过期";
        send: (
            number: 41110,
            fmt: "i",
            args: [
                /**称号id*/
                dsgtid: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**称号id*/
            dsgtid: number
        ];
        recv: {
            /** 返回码 1成功 */
            code: number;
        };
    };
}

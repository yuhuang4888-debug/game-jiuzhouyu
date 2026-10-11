/** 小精灵
 */
declare interface ProtoFmtInfo {
    16200: {
        desc: "错误码展示";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            errcode: number;
        };
    };
    16201: {
        desc: "场景广播";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 玩家ID */
            role_id: number;
            /** 玩家当前小精灵 */
            figure_id: number;
        };
    };
    16202: {
        desc: "小精灵列表";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 小精灵阶数 */
            lv: number;
            /** 当前星数 */
            star: number;
            /** 当前经验 */
            exp: number;
            /** 当前选择形象 */
            figure_id: number;
            /** 0非骑乘，1骑乘 */
            status: number;
            /** 坐骑战力 */
            combat: number;
            wing_list: {
                /** 已激活形象 */
                figure: number;
                /** 形象结束时间戳 0：永久 */
                end_time: number;
            }[];
        };
    };
    16203: {
        desc: "幻化小精灵";
        send: (
            number: 16203,
            fmt: "ic",
            args: [
                /**形象Id*/
                figure_id: number,
                /**0非骑乘，1骑乘*/
                type: number
            ]
        ) => never;
        sendFmt: "ic";
        sendArgs: [
            /**形象Id*/
            figure_id: number,
            /**0非骑乘，1骑乘*/
            type: number
        ];
        recv: {
            /** 形象Id */
            new_figure: number;
            /** 0非骑乘，1骑乘 */
            type: number;
            /** 1成功 */
            result: number;
        };
    };
    16205: {
        desc: "小精灵进阶";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 1成功 */
            result: number;
        };
    };
}

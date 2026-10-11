/** 魔法阵
 */
declare interface ProtoFmtInfo {
    21600: {
        desc: "错误码";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            errcode: number;
        };
    };
    21601: {
        desc: "魔法阵info";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            magic_circle: {
                /** 0 :未激活  1 已激活 */
                status: number;
                /** 1 :初级魔法阵 2 高级魔法阵 */
                lv: number;
                /** 结束时间戳 */
                end_time: number;
                /** 0 不幻化  1 幻化 */
                show: number;
                /** 0:普通魔法阵   1， 体验魔法阵 */
                free_flag: number;
            }[];
        };
    };
    21602: {
        desc: "召唤魔法阵";
        send: (
            number: 21602,
            fmt: "ccc",
            args: [
                /**魔法阵等级 1 :初级魔法阵 2 高级魔法阵*/
                lv: number,
                /**0: 普通召唤   1 特殊召唤*/
                type: number,
                /**0: 普通消耗  1，绑转消耗， 2钻石消耗*/
                auto: number
            ]
        ) => never;
        sendFmt: "ccc";
        sendArgs: [
            /**魔法阵等级 1 :初级魔法阵 2 高级魔法阵*/
            lv: number,
            /**0: 普通召唤   1 特殊召唤*/
            type: number,
            /**0: 普通消耗  1，绑转消耗， 2钻石消耗*/
            auto: number
        ];
        recv: {
            code: number;
        };
    };
    21603: {
        desc: "体验";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 1 :初级魔法阵 2 高级魔法阵 */
            lv: number;
        };
    };
    21604: {
        desc: "广播形象";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 玩家id */
            role_id: number;
            /** 魔法阵形象id */
            magic_circle_id: number;
        };
    };
    21605: {
        desc: "幻化形象";
        send: (
            number: 21605,
            fmt: "cc",
            args: [
                /**魔法阵等级*/
                lv: number,
                /**0 不幻化    1幻化。*/
                show: number
            ]
        ) => never;
        sendFmt: "cc";
        sendArgs: [
            /**魔法阵等级*/
            lv: number,
            /**0 不幻化    1幻化。*/
            show: number
        ];
        recv: null;
    };
    21606: {
        desc: "登录检查魔法阵过期";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 1 成功 */
            errcode: number;
        };
    };
}

/** 微信
 */
declare interface ProtoFmtInfo {
    11301: {
        desc: "分享信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            count: number;
        };
    };
    11302: {
        desc: "分享奖励领取";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            error_code: number;
        };
    };
    11303: {
        desc: "微信收藏：";
        send: (
            number: 11303,
            fmt: "c",
            args: [
                /**1 查看状态 2 收藏微信 3 领取奖励*/
                opr: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**1 查看状态 2 收藏微信 3 领取奖励*/
            opr: number
        ];
        recv: {
            error_code: number;
            /** 1 查看状态 2 收藏微信 3 领取奖励 */
            opr: number;
            /** 0 未收藏 1 已收藏未领奖励 2 已经领奖励 */
            wx_collect: number;
        };
    };
    11304: {
        desc: "分享奖励触发";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: null;
    };
    11305: {
        desc: "订阅消息";
        send: (
            number: 11305,
            fmt: "is",
            args: [
                /**订阅消息id*/
                temp_id: number,
                /** 平台*/
                package_code: string
            ]
        ) => never;
        sendFmt: "is";
        sendArgs: [
            /**订阅消息id*/
            temp_id: number,
            /** 平台*/
            package_code: string
        ];
        recv: null;
    };
    11306: {
        desc: "订阅情况";
        send: (number: 11306, fmt: any, args: [temp_list: any]) => never;
        sendFmt: any;
        sendArgs: [temp_list: any];
        recv: {
            temp_list: {
                /** 订阅消息id */
                temp_id: number;
                /** 0 未订阅 1 已订阅 */
                state: number;
            }[];
        };
    };
    11307: {
        desc: "订阅功能开关";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 0 关闭 1 开启 */
            res: number;
        };
    };
}

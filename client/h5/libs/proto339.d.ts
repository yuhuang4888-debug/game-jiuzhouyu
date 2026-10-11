/** 公会红包
 */
declare interface ProtoFmtInfo {
    33900: {
        desc: "错误码";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            errcode: number;
        };
    };
    33901: {
        desc: "公会红包列表";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            red_envelopes_list: {
                /** 红包唯一id */
                id: number;
                /** 玩家id */
                role_id: number;
                /**  玩家名字 */
                role_name: string;
                /** 职业 */
                career: number;
                /** 性别 */
                sex: number;
                /** 转生次数 */
                turn: number;
                /**  玩家头像 */
                picture: string;
                /** 玩家头像版本号 */
                picture_ver: number;
                /** 红包类型 */
                type: number;
                /** 系统赠送红包为配置id 道具红包为道具id */
                extra: number;
                /** 红包状态 0:未发 1:已发 2:已领完 */
                status: number;
                /** 领取状态 0: 无 1: 已领取 2: 可领取 */
                receive_status: number;
                /** 总数量 */
                total_num: number;
                /** 已领取人数 */
                recipients_num: number;
                msg: string;
                /** 发送时间 */
                stime: number;
            }[];
            record_list: {
                /** 记录唯一id */
                id: number;
                /**  玩家名字 */
                role_name: string;
                /** 红包配置id */
                cfg_id: number;
                /** 时间 */
                time: number;
            }[];
        };
    };
    33902: {
        desc: "打开红包";
        send: (
            number: 33902,
            fmt: "l",
            args: [
                /**红包唯一id*/
                red_envelopes_id: number
            ]
        ) => never;
        sendFmt: "l";
        sendArgs: [
            /**红包唯一id*/
            red_envelopes_id: number
        ];
        recv: {
            /** 红包唯一id */
            red_envelopes_id: number;
            /** 玩家id */
            role_id: number;
            /**  玩家名字 */
            role_name: string;
            /** 职业 */
            career: number;
            /** 性别 */
            sex: number;
            /** 转生次数 */
            turn: number;
            /**  玩家头像 */
            picture: string;
            /** 玩家头像版本号 */
            picture_ver: number;
            /** 红包状态 0:未发 1:已发 2:已领完 */
            status: number;
            /** 领取到的金额 */
            receive_money: number;
            /** 总数量 */
            total_num: number;
            /** 已领取人数 */
            recipients_num: number;
            /** 总额度 */
            money: number;
            /** 红包类型 */
            type: number;
            /** 系统赠送红包为配置id 道具红包为道具id */
            extra: number;
            recipient_list: {
                /** 玩家id */
                role_id: number;
                /**  玩家名字 */
                role_name: string;
                /** 职业 */
                career: number;
                /** 性别 */
                sex: number;
                /** 转生次数 */
                turn: number;
                /**  玩家头像 */
                picture: string;
                /** 玩家头像版本号 */
                picture_ver: number;
                /** 领取到的金额 */
                receive_money: number;
                /** 时间 */
                time: number;
            }[];
        };
    };
    33903: {
        desc: "设置红包拆分数量界面";
        send: (
            number: 33903,
            fmt: "cl",
            args: [
                /**红包类型*/
                type: number,
                /**系统奖励红包发红包唯一id 道具红包发道具类型id vip红包发0*/
                extra: number
            ]
        ) => never;
        sendFmt: "cl";
        sendArgs: [
            /**红包类型*/
            type: number,
            /**系统奖励红包发红包唯一id 道具红包发道具类型id vip红包发0*/
            extra: number
        ];
        recv: {
            /** 0: 没有次数限制 1: 有次数限制 */
            times_limit: number;
            /** 剩余发送次数 */
            remain_times: number;
            /** 总次数 */
            total_times: number;
            /** 默认拆分数量 */
            split_num: number;
        };
    };
    33904: {
        desc: "发送系统红包";
        send: (
            number: 33904,
            fmt: "lh",
            args: [
                /**红包唯一id*/
                id: number,
                /**拆分数量*/
                split_num: number
            ]
        ) => never;
        sendFmt: "lh";
        sendArgs: [
            /**红包唯一id*/
            id: number,
            /**拆分数量*/
            split_num: number
        ];
        recv: {
            /** 返回码 */
            errcode: number;
        };
    };
    33905: {
        desc: "使用红包道具发送红包";
        send: (
            number: 33905,
            fmt: "lih",
            args: [
                /**红包物品id*/
                goods_id: number,
                /**红包物品类型id*/
                gtype_id: number,
                /**拆分数量*/
                split_num: number
            ]
        ) => never;
        sendFmt: "lih";
        sendArgs: [
            /**红包物品id*/
            goods_id: number,
            /**红包物品类型id*/
            gtype_id: number,
            /**拆分数量*/
            split_num: number
        ];
        recv: {
            /** 返回码 */
            errcode: number;
        };
    };
    33906: {
        desc: "vip发送红包";
        send: (
            number: 33906,
            fmt: "ihs",
            args: [
                /**红包额度*/
                money: number,
                /**拆分数量*/
                split_num: number,
                /** vip红包描述*/
                msg: string
            ]
        ) => never;
        sendFmt: "ihs";
        sendArgs: [
            /**红包额度*/
            money: number,
            /**拆分数量*/
            split_num: number,
            /** vip红包描述*/
            msg: string
        ];
        recv: {
            /** 返回码 */
            errcode: number;
            /**  参数 */
            args: string;
        };
    };
    33907: {
        desc: "增加新的红包";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            red_envelopes_list: {
                /** 红包唯一id */
                id: number;
                /** 玩家id */
                role_id: number;
                /**  玩家名字 */
                role_name: string;
                /** 职业 */
                career: number;
                /** 性别 */
                sex: number;
                /** 转生次数 */
                turn: number;
                /**  玩家头像 */
                picture: string;
                /** 玩家头像版本号 */
                picture_ver: number;
                /** 红包类型 */
                type: number;
                /** 系统赠送红包为配置id 道具红包为道具id */
                extra: number;
                /** 红包状态 0:未发 1:已发 2:已领完 */
                status: number;
                /** 领取状态 1: 已领取 2: 可领取 */
                receive_status: number;
                /** 总数量 */
                total_num: number;
                /** 已领取人数 */
                recipients_num: number;
                msg: string;
                /** 发送时间 */
                stime: number;
            }[];
        };
    };
    33908: {
        desc: "红包领完消失";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 红包唯一id */
            id: number;
        };
    };
}

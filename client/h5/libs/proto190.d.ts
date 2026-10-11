/** 信件信息
 */
declare interface ProtoFmtInfo {
    19000: {
        desc: "错误码";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            error_code: number;
        };
    };
    19001: {
        desc: "获得邮件基本信息列表";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            mail_list: {
                /** 邮件id */
                mail_id: number;
                /** 邮件类型（1系统;2私人;3公会） */
                type: number;
                /** 邮件状态（1已读;2未读;3已领取附件） */
                state: number;
                /**  标题 */
                title: string;
                /** 有无附件（0无;1有） */
                is_attach: number;
                /** 时间戳 */
                time: number;
                /** 有效结束时间 */
                effect_et: number;
            }[];
        };
    };
    19002: {
        desc: "获得邮件详细信息";
        send: (
            number: 19002,
            fmt: "l",
            args: [
                /**邮件id*/
                mail_id: number
            ]
        ) => never;
        sendFmt: "l";
        sendArgs: [
            /**邮件id*/
            mail_id: number
        ];
        recv: {
            /** 邮件id */
            mail_id: number;
            /**  发件人名字 */
            sender: string;
            /**  邮件标题 */
            title: string;
            /**  邮件内容 */
            content: string;
            /** 附件 */
            attachment: {
                /** 物品类型 */
                object_type: number;
                /** 物品类型id */
                type_id: number;
                /** 数量 */
                num: number;
                /** 物品附加属性 目前只用作装备的极品属性 */
                extra_attr: {
                    /** 颜色 参考后台颜色配置 */
                    color: number;
                    /** 类型 1: 成长型属性 2: 百分比加成属性 */
                    type_id: number;
                    /** 属性类型 */
                    attr_id: number;
                    /** 属性值 */
                    attr_val: number;
                    /** 每多少级增加(成长型属性使用) */
                    plus_interval: number;
                    /** 每隔多少级增加多少属性(成长型属性使用) */
                    plus_unit: number;
                }[];
            }[];
            /** 时间 */
            time: number;
            /** 附件是否已经领取 0:未领取 1:已领取 */
            is_receive: number;
        };
    };
    19003: {
        desc: "删除邮件";
        send: (number: 19003, fmt: any, args: [mail_ids: any]) => never;
        sendFmt: any;
        sendArgs: [mail_ids: any];
        recv: {
            /** 错误码 */
            error_code: number;
            mail_ids: {
                /** 邮件id */
                mail_id: number;
            }[];
        };
    };
    19004: {
        desc: "增加邮件";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            mail_list: {
                /** 邮件id */
                mail_id: number;
                /** 邮件类型（1系统;2私人;3公会） */
                type: number;
                /** 邮件状态（1已读;2未读;3已领取附件） */
                state: number;
                /**  标题 */
                title: string;
                /** 有无附件（0无;1有） */
                is_attach: number;
                /** 时间戳 */
                time: number;
                /** 有效结束时间 */
                effect_et: number;
            }[];
        };
    };
    19005: {
        desc: "提取附件";
        send: (number: 19005, fmt: any, args: [mail_ids: any]) => never;
        sendFmt: any;
        sendArgs: [mail_ids: any];
        recv: {
            /** 错误码 */
            error_code: number;
            mail_ids: {
                /** 邮件id */
                mail_id: number;
            }[];
            reward: any;
        };
    };
    19006: {
        desc: "发送公会邮件";
        send: (
            number: 19006,
            fmt: "ss",
            args: [
                /** 邮件标题*/
                title: string,
                /** 邮件内容*/
                content: string
            ]
        ) => never;
        sendFmt: "ss";
        sendArgs: [
            /** 邮件标题*/
            title: string,
            /** 邮件内容*/
            content: string
        ];
        recv: {
            /** 错误码 */
            error_code: number;
        };
    };
    19007: {
        desc: "获得邮件基本信息";
        send: (
            number: 19007,
            fmt: "l",
            args: [
                /**邮件id*/
                mail_id: number
            ]
        ) => never;
        sendFmt: "l";
        sendArgs: [
            /**邮件id*/
            mail_id: number
        ];
        recv: {
            /** 邮件id */
            mail_id: number;
            /** 邮件类型（1系统;2私人;3公会） */
            type: number;
            /** 邮件状态（1已读;2未读;3已领取附件） */
            state: number;
            /**  标题 */
            title: string;
            /** 有无附件（0无;1有） */
            is_attach: number;
            /** 时间戳 */
            time: number;
            /** 有效结束时间 */
            effect_et: number;
        };
    };
    19008: {
        desc: "邮件通知";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 是否有未读邮件 0:无未读邮件 1:有未读邮件 */
            is_unread_mail: number;
        };
    };
    19009: {
        desc: "公会邮件发送次数";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 发送公会邮件的剩余次数 */
            left_num: number;
        };
    };
    19010: {
        desc: "处理玩家反馈信息";
        send: (
            number: 19010,
            fmt: "s",
            args: [
                /** 内容*/
                content: string
            ]
        ) => never;
        sendFmt: "s";
        sendArgs: [
            /** 内容*/
            content: string
        ];
        recv: {
            /** 错误码 */
            error_code: number;
        };
    };
}

/** 新版boss首杀
 */
declare interface ProtoFmtInfo {
    18800: {
        desc: "通用错误码";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            code: number;
        };
    };
    18801: {
        desc: "界面信息";
        send: (
            number: 18801,
            fmt: "cc",
            args: [
                /**活动类型*/
                type: number,
                /**活动子类型*/
                subtype: number
            ]
        ) => never;
        sendFmt: "cc";
        sendArgs: [
            /**活动类型*/
            type: number,
            /**活动子类型*/
            subtype: number
        ];
        recv: {
            /** 活动类型 */
            type: number;
            /** 活动子类型 */
            subtype: number;
            first_blood_list: {
                /** 是否显示首杀归属，1：显示，0：不显示 */
                show_first_blood: number;
                /** boss id */
                boss_id: number;
                /** 首杀玩家id */
                first_blood_role_id: number;
                /**  全服首杀玩家名称 */
                first_blood_role_name: string;
                /** 首杀玩家等级 */
                role_lv: number;
                /** 首杀玩家性别 */
                role_sex: number;
                /** 首杀玩家职业 */
                role_carrer: number;
                /**  首杀玩家头像 */
                picture: string;
                /** 首杀玩家头像版本 */
                picture_ver: number;
                /** 装扮列表 */
                dress_list: {
                    /** 装扮类型 */
                    dress_type: number;
                    /** 装扮id */
                    dress_id: number;
                }[];
                /** 当前玩家获取奖励状态（0：未领取，1：已领取，2：不可领取）(Boss首杀此状态为个人奖励领取状态) */
                reward_state: number;
            }[];
        };
    };
    18802: {
        desc: "领取奖励";
        send: (
            number: 18802,
            fmt: "cci",
            args: [
                /**活动类型*/
                type: number,
                /**活动子类型*/
                subtype: number,
                /**boss id*/
                boss_id: number
            ]
        ) => never;
        sendFmt: "cci";
        sendArgs: [
            /**活动类型*/
            type: number,
            /**活动子类型*/
            subtype: number,
            /**boss id*/
            boss_id: number
        ];
        recv: {
            /** 活动类型 */
            type: number;
            /** 活动子类型 */
            subtype: number;
            /** 错误码 */
            code: number;
            /** boss id */
            boss_id: number;
            reward_list: any;
        };
    };
    18803: {
        desc: "未领取全服奖励弹窗";
        send: (
            number: 18803,
            fmt: "cc",
            args: [
                /**活动类型*/
                type: number,
                /**活动子类型*/
                subtype: number
            ]
        ) => never;
        sendFmt: "cc";
        sendArgs: [
            /**活动类型*/
            type: number,
            /**活动子类型*/
            subtype: number
        ];
        recv: {
            /** 活动类型 */
            type: number;
            /** 活动子类型 */
            subtype: number;
            /**  全服首杀玩家名称 */
            first_blood_role_name: string;
            /**  提醒的boss名字 */
            boss_name: string;
        };
    };
    18804: {
        desc: "副本首通界面";
        send: (
            number: 18804,
            fmt: "cci",
            args: [
                /**活动类型*/
                type: number,
                /**活动子类型*/
                subtype: number,
                /**副本id*/
                dun_id: number
            ]
        ) => never;
        sendFmt: "cci";
        sendArgs: [
            /**活动类型*/
            type: number,
            /**活动子类型*/
            subtype: number,
            /**副本id*/
            dun_id: number
        ];
        recv: {
            /** 活动类型 */
            type: number;
            /** 活动子类型 */
            subtype: number;
            /** 副本id */
            dun_id: number;
            /** 领取状态（0：未领取，1：已领取，2：不可领取） */
            reward_state: number;
            /** 排行榜 */
            pass_role_list: {
                /** 玩家id */
                role_id: number;
                /**  玩家名字 */
                role_name: string;
                /** 排名 */
                rank: number;
                /** 等级 */
                role_lv: number;
                /** 玩家性别 */
                role_sex: number;
                /** 玩家职业 */
                role_carrer: number;
                /**  头像 */
                picture: string;
                /** 头像版本 */
                picture_ver: number;
                /** 装扮列表 */
                dress_list: {
                    /** 装扮类型 */
                    dress_type: number;
                    /** 装扮id */
                    dress_id: number;
                }[];
                /** 时间戳 */
                time: number;
            }[];
        };
    };
    18805: {
        desc: "副本首通界面红点";
        send: (
            number: 18805,
            fmt: "cc",
            args: [
                /**活动类型*/
                type: number,
                /**活动子类型*/
                subtype: number
            ]
        ) => never;
        sendFmt: "cc";
        sendArgs: [
            /**活动类型*/
            type: number,
            /**活动子类型*/
            subtype: number
        ];
        recv: {
            /** 活动类型 */
            type: number;
            /** 活动子类型 */
            subtype: number;
            /** 红点列表 */
            red_point_list: {
                /** 副本id */
                dun_id: number;
                /** 显示红点(1：是， 2：已领取) */
                show_point: number;
            }[];
        };
    };
    18806: {
        desc: "查询Boss首杀全服归属奖励状态";
        send: (
            number: 18806,
            fmt: "cci",
            args: [
                /**活动类型*/
                type: number,
                /**活动子类型*/
                subtype: number,
                /**boss id*/
                boss_id: number
            ]
        ) => never;
        sendFmt: "cci";
        sendArgs: [
            /**活动类型*/
            type: number,
            /**活动子类型*/
            subtype: number,
            /**boss id*/
            boss_id: number
        ];
        recv: {
            /** 活动类型 */
            type: number;
            /** 活动子类型 */
            subtype: number;
            /** boss id */
            boss_id: number;
            /** 当前玩家获取奖励状态（0：未领取，1：已领取，2：不可领取） */
            shared_status: number;
        };
    };
    18807: {
        desc: "Boss首杀领取全服归属奖励";
        send: (
            number: 18807,
            fmt: "cci",
            args: [
                /**活动类型*/
                type: number,
                /**活动子类型*/
                subtype: number,
                /**boss id*/
                boss_id: number
            ]
        ) => never;
        sendFmt: "cci";
        sendArgs: [
            /**活动类型*/
            type: number,
            /**活动子类型*/
            subtype: number,
            /**boss id*/
            boss_id: number
        ];
        recv: {
            /** 活动类型 */
            type: number;
            /** 活动子类型 */
            subtype: number;
            /** 错误码 */
            code: number;
            /** boss id */
            boss_id: number;
            reward_list: any;
        };
    };
}

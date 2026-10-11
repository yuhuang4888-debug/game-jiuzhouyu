/** 嗨点
 */
declare interface ProtoFmtInfo {
    33300: {
        desc: "嗨点信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            list: {
                /** 活动主类型 */
                base_type: number;
                /** 活动子类型 */
                sub_type: number;
                /**  活动名字 */
                name: string;
                /** 开始时间 */
                stime: number;
                /** 结束时间 */
                etime: number;
                show_id: number;
            }[];
        };
    };
    33302: {
        desc: "嗨点详情";
        send: (
            number: 33302,
            fmt: "hh",
            args: [
                /**活动主类型*/
                base_type: number,
                /**活动子类型*/
                sub_type: number
            ]
        ) => never;
        sendFmt: "hh";
        sendArgs: [
            /**活动主类型*/
            base_type: number,
            /**活动子类型*/
            sub_type: number
        ];
        recv: {
            /** 活动主类型 */
            base_type: number;
            /** 活动子类型 */
            sub_type: number;
            /** 获得总嗨点值 */
            sum_points: number;
            mod_list: {
                /** 模块id */
                mod_id: number;
                sub_id: number;
                condition_type: string;
                /**  名称 */
                name: string;
                /** 排序id */
                order_id: number;
                /** 跳转id */
                jump_id: number;
                /** 保留值 */
                sec_value: number;
                /**  模块图片 */
                icon_type: string;
                /** 进度值 */
                pro_value: number;
                /** 是否显示进度 */
                is_pro: number;
                /** 目标值 */
                condi_val: number;
                /** 奖励嗨点 */
                reward_point: number;
                /**  描述 */
                dec: string;
                /** 是否已完成 */
                is_com: number;
            }[];
        };
    };
    33303: {
        desc: "获取奖励领取状态";
        send: (
            number: 33303,
            fmt: "hh",
            args: [
                /**活动主类型*/
                base_type: number,
                /**活动子类型*/
                sub_type: number
            ]
        ) => never;
        sendFmt: "hh";
        sendArgs: [
            /**活动主类型*/
            base_type: number,
            /**活动子类型*/
            sub_type: number
        ];
        recv: {
            /** 活动主类型 */
            base_type: number;
            /** 活动子类型 */
            sub_type: number;
            reward_list: {
                /** 奖励档次 */
                grade: number;
                /** 奖励格式类型 见后台备注 */
                form_type: number;
                /** 领取状态 0:未达到 1:可以领取 2:已经领取 3:奖励超时 */
                status: number;
                /** 已领取次数 */
                receive_times: number;
                /**  奖励名字 */
                name: string;
                /**  奖励描述 */
                desc: string;
                /**  领取条件 */
                condition: string;
                /**  奖励 具体参考后台配置的格式 */
                reward: string;
            }[];
        };
    };
    33304: {
        desc: "领取活动奖励";
        send: (
            number: 33304,
            fmt: "hhh",
            args: [
                /**活动主类型*/
                base_type: number,
                /**活动子类型*/
                sub_type: number,
                /**奖励档次*/
                grade: number
            ]
        ) => never;
        sendFmt: "hhh";
        sendArgs: [
            /**活动主类型*/
            base_type: number,
            /**活动子类型*/
            sub_type: number,
            /**奖励档次*/
            grade: number
        ];
        recv: {
            /** 活动主类型 */
            base_type: number;
            /** 活动子类型 */
            sub_type: number;
            /** 奖励档次 */
            grade: number;
        };
    };
    33305: {
        desc: "单次嗨点信息（主动推送）";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 活动主类型 */
            base_type: number;
            /** 活动子类型 */
            sub_type: number;
            /** 获得总嗨点值 */
            sum_points: number;
            mod_list: {
                /** 模块id */
                mod_id: number;
                sub_id: number;
                condition_type: string;
                /**  名称 */
                name: string;
                /** 进度值 */
                pro_value: number;
                /** 是否已完成 */
                is_com: number;
            }[];
        };
    };
    33306: {
        desc: "统一错误出口";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 返回码 */
            error_code: number;
        };
    };
}

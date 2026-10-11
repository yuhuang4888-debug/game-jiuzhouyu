/** 至尊vip信息
 */
declare interface ProtoFmtInfo {
    45101: {
        desc: "查看至尊vip信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 至尊vip类型##0:无;1:体验vip;2:永久vip */
            supvip_type: number;
            /** 至尊vip过期时间##类型等于体验vip有效果 */
            supvip_time: number;
            right_list: {
                /** 特权类型 */
                right_type: number;
                /**  特殊数据 */
                data_str: string;
                utime: number;
            }[];
            /** 充值天数 */
            charge_day: number;
            /** 今日充值数 */
            today_gold: number;
            /** 是否有免费的免战保护 */
            is_free_protect: number;
        };
    };
    45102: {
        desc: "查看技能任务";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 当天阶段 */
            stage: number;
            /** 子阶段##根据任务提交数计算 */
            sub_stage: number;
            task_list: {
                /** 任务id */
                task_id: number;
                /** 是否完成(1:可以提交) */
                is_finish: number;
                /** 是否提交(1:已经提交了) */
                is_commit: number;
                /**  内容##e.g:[{1,N,M}] */
                content: string;
            }[];
        };
    };
    45103: {
        desc: "提交技能任务";
        send: (
            number: 45103,
            fmt: "h",
            args: [
                /**任务id*/
                task_id: number
            ]
        ) => never;
        sendFmt: "h";
        sendArgs: [
            /**任务id*/
            task_id: number
        ];
        recv: {
            /** 错误码 */
            error_code: number;
            /** 任务id */
            task_id: number;
            /** 是否升阶 */
            is_up: number;
        };
    };
    45104: {
        desc: "查看至尊币任务";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            task_list: {
                /** 任务id */
                task_id: number;
                /** 是否完成(1:可以提交) */
                is_finish: number;
                /** 是否提交(1:已经提交了) */
                is_commit: number;
                /**  内容##e.g:[{1,N}] */
                content: string;
            }[];
        };
    };
    45105: {
        desc: "提交至尊币任务";
        send: (
            number: 45105,
            fmt: "h",
            args: [
                /**任务id*/
                task_id: number
            ]
        ) => never;
        sendFmt: "h";
        sendArgs: [
            /**任务id*/
            task_id: number
        ];
        recv: {
            /** 错误码 */
            error_code: number;
            /** 任务id */
            task_id: number;
        };
    };
    45106: {
        desc: "购买至尊vip体验";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            error_code: number;
        };
    };
    45107: {
        desc: "购买至尊vip永久";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            error_code: number;
        };
    };
    45108: {
        desc: "领取特权8:日常奖励";
        send: (
            number: 45108,
            fmt: "c",
            args: [
                /**特权类型*/
                right_type: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**特权类型*/
            right_type: number
        ];
        recv: {
            /** 错误码 */
            error_code: number;
            /** 特权类型 */
            right_type: number;
        };
    };
    45109: {
        desc: "充值提升至尊vip";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: null;
    };
    45110: {
        desc: "技能任务更新";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            task_list: {
                /** 任务id */
                task_id: number;
                /** 是否完成(1:可以提交) */
                is_finish: number;
                /** 是否提交(1:已经提交了) */
                is_commit: number;
                /**  内容##e.g:[{1,N,M}] */
                content: string;
            }[];
        };
    };
    45111: {
        desc: "至尊币任务更新";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            task_list: {
                /** 任务id */
                task_id: number;
                /** 是否完成(1:可以提交) */
                is_finish: number;
                /** 是否提交(1:已经提交了) */
                is_commit: number;
                /**  内容##e.g:[{1,N}] */
                content: string;
            }[];
        };
    };
    45112: {
        desc: "免战保护信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 是否有免费 */
            is_free: number;
        };
    };
}

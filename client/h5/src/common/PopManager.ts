import { BaseView1 } from "./BaseView1";
export class PopManager {
    static Instance: PopManager;
    popViewOpen;
    popViewClocse;
    public constructor() {
        let open_view_dic: {
            [id: number]: BaseView1;
        } = {}, //保存打开的window
        open_view_hashCode: number; //已打开window的哈希值
        this.popViewOpen = (bView: BaseView1): void => {
            let view: BaseView1;
            if (bView.hashCode != open_view_hashCode) {
                view = open_view_dic[open_view_hashCode];
                if (view)
                    view.Close();
                open_view_hashCode = bView.hashCode;
                open_view_dic[bView.hashCode] = bView;
            }
        };
        this.popViewClocse = (bView: BaseView1): void => {
            delete open_view_dic[bView.hashCode];
            if (bView.hashCode == open_view_hashCode) {
                open_view_hashCode = null;
            }
        };
    }
    public static GetInstance() {
        if (!PopManager.Instance) {
            PopManager.Instance = new PopManager();
        }
        return PopManager.Instance;
    }
}

window["PopManager"] = PopManager
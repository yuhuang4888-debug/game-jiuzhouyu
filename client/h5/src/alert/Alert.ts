import { BaseAlert } from "./BaseAlert"
import { AlertTypeCheckBox } from "./AlertTypeCheckBox";
import { AlertTypeCheckBox2 } from "./AlertTypeCheckBox2";
import { AlertTypeOne } from "./AlertTypeOne";
import { AlertTypeThree } from "./AlertTypeThree";
import { AlertTypeTwo } from "./AlertTypeTwo";
import { AlertTypeTreasure } from "./AlertTypeTreasure";

export enum Alert_Type {
    One,
    Two,
    Three,
    AlertTypeCheckBox,
    AlertTypeCheckBox2,
    AlertTypeTreasure
}

window["Alert_Type"] = Alert_Type;

export class AlertConfig {
    show_content: string
    type: Alert_Type
    ok_callback: () => void
    cancel_callback: () => void
    ok_text: string
    cancel_text: string
    left_time: number
    is_close_hide: boolean
    check_callback: () => void
    check_text: string
    use_background: boolean
    good_source
    target_text: string
    title_text: string
    three_top_text: string
    three_down_text: string
    show_close_ani: boolean
    title_img
    close_callback: () => void
    is_hide_check: boolean
}
window["AlertConfig"] = AlertConfig;
export class Alert {
    private static curr_view: BaseAlert
    public static ShowWithConfig(cfg: AlertConfig) {
        let {show_content, type, ok_callback, cancel_callback, ok_text, cancel_text, left_time, is_close_hide, check_callback, check_text, use_background, good_source, target_text, title_text, three_top_text, three_down_text, show_close_ani, title_img, close_callback, is_hide_check} = cfg;
        Alert.Show(show_content, type, ok_callback, cancel_callback, ok_text, cancel_text, left_time, is_close_hide, check_callback, check_text, use_background, good_source, target_text, title_text, three_top_text, three_down_text, show_close_ani, title_img, close_callback, is_hide_check);
    }
    /**
     * @param  {} show_content 111222333
     * @param  {} type
     * @param  {} ok_callback
     * @param  {} cancel_callback
     * @param  {} ok_text
     * @param  {} cancel_text
     * @param  {} left_time
     * @param  {} is_close_hide
     * @param  {} check_callback
     * @param  {} check_text
     * @param  {} use_background
     * @param  {} good_source
     * @param  {} target_text
     * @param  {} title_text
     */
    public static Show(show_content, type: number = Alert_Type.One, ok_callback?, cancel_callback?, ok_text?, cancel_text?, left_time?, is_close_hide?, check_callback?, check_text?, use_background?, good_source?, target_text?, title_text?, three_top_text?, three_down_text?, show_close_ani?, title_img?, close_callback?, is_hide_check?) {
        if (Alert.curr_view) {
            if (Alert.curr_view.HasOpen())
                Alert.curr_view.Close()
            Alert.curr_view.DeleteMe()
            Alert.curr_view = undefined
        }
        let class_name = undefined
        switch (type) {
            case Alert_Type.One:
                class_name = AlertTypeOne
                break
            case Alert_Type.Two:
                class_name = AlertTypeTwo
                break
            case Alert_Type.AlertTypeCheckBox:
                class_name = AlertTypeCheckBox
                break
            case Alert_Type.AlertTypeCheckBox2:
                class_name = AlertTypeCheckBox2
                break
            case Alert_Type.Three:
                class_name = AlertTypeThree
                break
            case Alert_Type.AlertTypeTreasure:
                class_name = AlertTypeTreasure
                break
        }

        if (class_name) {
            Alert.curr_view = new class_name(show_content, type, ok_callback, cancel_callback, ok_text, cancel_text, left_time, is_close_hide, check_callback, check_text, use_background, good_source, target_text, title_text, three_top_text, three_down_text, show_close_ani, title_img, close_callback, is_hide_check)
            Alert.curr_view.Open()
        }
        return Alert.curr_view
    }

    public static Close() {
        let a = Alert
        if (a.curr_view && a.curr_view.HasOpen()) {
            a.curr_view.Close()
            a.curr_view = undefined
        }
    }

    static has_show_msg_list = {}
    //重复打开多个 测试用
    public static RepeatShow(show_content: string, type: number = Alert_Type.One, ok_callback?, cancel_callback?, ok_text?, cancel_text?, left_time?, is_close_hide?, check_callback?, check_text?, use_background?, good_source?, target_text?, title_text?, three_top_text?, three_down_text?, show_close_ani?, title_img?, close_callback?) {
        if (Alert.has_show_msg_list[show_content]) return
        Alert.has_show_msg_list[show_content] = true
        let class_name = undefined
        switch (type) {
            case Alert_Type.One:
                class_name = AlertTypeOne
                break
            case Alert_Type.Two:
                class_name = AlertTypeTwo
                break
            case Alert_Type.AlertTypeCheckBox:
                class_name = AlertTypeCheckBox
                break
            case Alert_Type.Three:
                class_name = AlertTypeThree
                break
        }
        if (class_name) {
            let a_view = new class_name(show_content, Alert_Type.One, ok_callback, cancel_callback, ok_text, cancel_text, left_time, is_close_hide, check_callback, check_text, use_background, good_source, target_text, title_text, three_top_text, three_down_text, show_close_ani, title_img, close_callback)
            a_view.Open()
            return a_view
        }
    }
    public static SetIsCharge(b) {
        Alert.curr_view.is_charge = b;
    }
}
window["Alert"] = Alert
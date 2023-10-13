/**
 * 实体字符解码
 * @param {*} text 待解码的文本
 * @returns
 */
export function entitiesDecode(text) {
  text = text.replace(/&amp;/g, "&");
  text = text.replace(/&lt;/g, "<");
  text = text.replace(/&gt;/g, ">");
  text = text.replace(/&nbsp;/g, " ");
  text = text.replace(/&quot;/g, "'");
  text = text.replace(/&quot;/g, "'");
  text = text.replace(/&middot;/g, "");
  return text;
}
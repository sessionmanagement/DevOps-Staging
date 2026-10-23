       
1.      **General purpose** of each label, user can increase the level of sensitivity label, but when decrease the level of sensitivity, prompt asking for justification.
a.      Public
Press release, social media release. Only available to Comms team (Communication team). No one else should use this label. If sensitive information types are detected in the document, the document will be blocked from being sent externally. The user will be prompted to change the label to sensitive (this might be automatic later).
b.      In-confidence
For all documents and communications not containing any sensitive information or data. If sensitive information types are detected in the document, the document will be blocked from being sent externally. The user will be prompted to change the label to sensitive (this might be automatic later).
c.      Sensitive
For all documents and communications that contains sensitive information or data.
d.      Restricted
Any documentations or communications that needs to be restricted to internal groups.
2.      **(First draft, might change slightly later)Expected behaviour** - What is the expected behaviour for each label?  What should the label allow / not allow? What does it block, if any? Visual indicators (eg. Watermarks, headers, banners)? Any prompts / warnings?
a.      Outlook
                                                              i.      Public
No watermarking, no restrictions on sending. There will be email tips (prompt).
                                                            ii.      In-confidence
Has in-confidence watermark, no restriction on sending. There will be email tips.
                                                          iii.      Sensitive
Has sensitive watermark, no restriction on sending. There will be email tips.
                                                           iv.      Restricted
Has restricted watermark, cannot be send externally. There will be a block on externally sending with emails bounced back. There will be email tips. Prompt a dialog box, picking the audience. Locked to the selected audience.
b.      Word
                                                              i.      Public
Same as outlook, except for not having email tips.
                                                            ii.      In-confidence
Same as outlook, except for not having email tips.
                                                          iii.      Sensitive
Same as outlook, except for not having email tips.
                                                           iv.      Restricted
Same as outlook, except for not having email tips.
c.      Excel
                                                              i.      Public
                                                            ii.      Same as outlook, except for not having email tips.
                                                          iii.      In-confidence
                                                           iv.      Same as outlook, except for not having email tips.
                                                            v.      Sensitive
                                                           vi.      Same as outlook, except for not having email tips.
                                                         vii.      Restricted
                                                       viii.      Same as outlook, except for not having email tips.
                                                           ix.      In-confidence
                                                           ix.      Sensitive
                                                             x.      Restricted
d.      Power Point
                                                              i.      Public
                                                            ii.      Same as outlook, except for not having email tips.
                                                          iii.      In-confidence
                                                           iv.      Same as outlook, except for not having email tips.
                                                            v.      Sensitive
                                                           vi.      Same as outlook, except for not having email tips.
                                                         vii.      Restricted
                                                       viii.      Same as outlook, except for not having email tips.
                                                           ix.      In-confidence
                                                           ix.      Sensitive
                                                             x.      Restricted
e.      OneNote
                                                              i.      Public
Same as outlook, except for not having email tips.
                                                            ii.      In-confidence
Same as outlook, except for not having email tips.
                                                          iii.      Sensitive
Same as outlook, except for not having email tips.
                                                           iv.      Restricted
Same as outlook, except for not having email tips.
f.        PDF (file level locking, one level deeper in the Outlook. But worth to test, with different PDF reader. )
3.      **(Similar to above, look into a different question.)Configuration** - No fully detail, just a high-level idea of the configurations for each label. Ie watermarks, encryption, behaviours?
a.      In-confidence
b.      Sensitive
c.      Restricted
4.      **Failure Scenarios** - What should happen if someone tries to break the rules? What specific actions should be blocked for each label?
a.      Public
Anyone outside of Comm should have no public label option in the dropdown.
If sensitive information is detected in the document, a warning prompt will be presented. And won't be able to send externally.
b.      In-confidence             
If sensitive information is detected in the document, a warning prompt will be presented. And won't be able to send externally.
c.      Sensitive
Email prompt will be presented to sender, “Check if you recipient is correct.”
d.      Restricted
Block sending externally. Cannot be read by anyone outside of the white list. Get email bounced back.
5.      **Edge Cases** (optional more advance) – Collaboration, Offline. What happens when multiple users edit the same labeled file in Teams or SharePoint? Can labels still enforces restrictions if the file is offline? What happens if the labelled file is edited offline?
a.      Change label offline.
b.      Sender sends restricted email. And the recipient forward the restricted email.
c.      Restricted PDFs read by different PDF readers.
d.      Whether the sharing permission has impacted on sensitivity label.
e.      Access sensitive document offline, while the label level decreases by the sender.
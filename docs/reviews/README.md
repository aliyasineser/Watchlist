# Current review

Main at 8008307 includes features 01–12. The active review is
`feature/13-navigation-and-icloud-account`, based on that commit:
[Navigation and iCloud Account review](13-navigation-and-icloud-account.md).

The user chose system iCloud account persistence rather than a separate app login.
Discover, Search, Library, Upcoming and Account now have distinct responsibilities.
Existing sync requires a one-time iCloud identity confirmation after this upgrade;
new/different accounts require confirmation before merging local data. Existing
CloudKit provisioning still applies. Local data is retained if sync is unavailable.

Run `Scripts/test.sh` or PR CI before merging. Review the five-tab navigation, all
moved tools, card spacing, dark/large-text screenshot attachments, offline flows
and signed-device account changes. Local static checks are not full compilation,
runtime execution or visual approval. Xcode/SwiftPM cache permissions and
CoreSimulator remain blocked in the editing sandbox.

Prior reviews:
- [Continue watching](10-continue-watching.md)
- [Custom lists](11-custom-lists.md)
- [Choose together](12-choose-together.md)
- [Backup and sync](07-library-backup-sync.md)
- [Where to watch](08-where-to-watch.md)
- [Upcoming](09-upcoming-reminders.md)
